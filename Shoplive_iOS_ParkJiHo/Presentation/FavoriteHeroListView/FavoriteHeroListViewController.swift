//
//  FavoriteHeroListViewController.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class FavoriteHeroListViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView!
    private let emptyView = EmptyView(emptyMessage: EmptyViewMessage.favoriteHeroListView.rawValue)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MarvelHeroCell.self, forCellWithReuseIdentifier: MarvelHeroCell.identifier)
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setUpConstraints()
        setUpView()
    }
    
    private func addSubview() {
        self.view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setUpView() {
        collectionView.backgroundView = emptyView
    }
    
    func bind(reactor: FavoriteHeroListViewReactor) {
        // action
        self.rx.viewDidLoad
            .map { _ in FavoriteHeroListViewReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state
        reactor.pulse(\.$heroCellReactors)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] reactors in
                self?.collectionView.reloadData()
                self?.emptyView.isHidden = reactors?.count != 0
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.rx.handleError)
            .disposed(by: disposeBag)
        
        // collectionView
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let state = self?.reactor?.currentState.heroCellReactors?[indexPath.row].currentState else {
                    return
                }
                if state.isFavorite {
                    self?.reactor?.action.onNext(.cancelFavoriteHero(state.hero.id))
                }
            })
            .disposed(by: disposeBag)
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

// MARK: - UICollectionViewDataSource

extension FavoriteHeroListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactors = self.reactor?.currentState.heroCellReactors else { return 0 }
        return reactors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelHeroCell.identifier,
                                                            for: indexPath) as?  MarvelHeroCell else {
            return UICollectionViewCell()
        }
        
        guard let reactor = self.reactor?.currentState.heroCellReactors?[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.reactor = reactor
        return cell
    }
}
