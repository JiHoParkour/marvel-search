//
//  MarvelHeroCell.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import UIKit

import ReactorKit
import SnapKit

final class MarvelHeroCell: UICollectionViewCell, View {
    
    static let identifier = "MarvelHeroCell"
    
    var disposeBag = DisposeBag()
    
    static var imageSize: CGSize {
        let minimumInteritemSpacing: CGFloat = 20
        let margin: CGFloat = 20
        let imageWidth: CGFloat = (UIScreen.main.bounds.width - minimumInteritemSpacing - (margin * 2)) / 2
        return CGSize(width: imageWidth, height: imageWidth)
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let heroImageView: KingfisherImageView = {
        let imageView = KingfisherImageView()
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(rawValue: 200), for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        setUpconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(heroImageView)
        self.contentView.addSubview(descriptionLabel)
    }
    
    private func setUpconstraints() {
        heroImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.width.equalTo(MarvelHeroCell.imageSize.width)
            make.height.equalTo(MarvelHeroCell.imageSize.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func bind(reactor: MarvelHeroCellReactor) {
        //state
        reactor.state
            .map(\.hero.name)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.hero.thumbnailPath)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.heroImageView.loadImage(imagePath: $0,
                                              downsamplingSize: MarvelHeroCell.imageSize)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.hero.description)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isFavorite)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] isFavorite in
                self?.contentView.backgroundColor = isFavorite ? .gray : .white
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.cancelDownloadTask()
    }
}
