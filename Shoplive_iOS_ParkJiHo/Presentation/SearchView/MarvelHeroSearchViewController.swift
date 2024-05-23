//
//  MarvelHeroSearchViewController.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class MarvelHeroSearchViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MarvelHeroCell.self, forCellWithReuseIdentifier: MarvelHeroCell.identifier)
        collectionView.dataSource = self
        addSubview()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: MarvelHeroSearchViewReactor) {
        reactor.pulse(\.$heroCellReactors)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
            
        searchBar.rx.value.changed
            .compactMap { $0 }
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                reactor.action.onNext(.searchTermChanged(text))
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.scrolled(portion: 0.9)
            .map { Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    
    private func addSubview() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(loadingIndicator)
    }
    
    private func setUpConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let itemWidth: CGFloat = MarvelHeroCell.imageSize.width
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.6)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        
        return layout
    }
}

extension MarvelHeroSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let reactors = self.reactor?.currentState.heroCellReactors else { return 0 }
                
        return reactors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelHeroCell.identifier, for: indexPath) as?  MarvelHeroCell else { return UICollectionViewCell() }
        
        guard let reactor = self.reactor?.currentState.heroCellReactors?[safe: indexPath.row] else { return UICollectionViewCell() }
        cell.reactor = reactor
        
        return cell
    }
}
