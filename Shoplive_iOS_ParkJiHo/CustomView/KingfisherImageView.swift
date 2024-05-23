//
//  KingfisherImageView.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import UIKit

import Kingfisher

final class KingfisherImageView: UIImageView {
        
    public init() {
        super.init(frame: .zero)
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(imagePath: String?,
                   downsamplingSize: CGSize? = nil,
                   completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        
        guard let imagePath = imagePath, imagePath.isNotEmpty,
              let imageURL = URL(string: imagePath) else { return }
        self.kf.setImage(with: imageURL,
                         options: kingfisherOptions(downsamplingSize)) { result in
            
            if case .failure = result {
                self.image = UIImage(systemName: "photo")
            }
            completionHandler?(result)
        }
    }
    
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }
    
    private func kingfisherOptions(_ downsamplingSize: CGSize?) -> KingfisherOptionsInfo {
        var options: KingfisherOptionsInfo = .init()
        options.append(contentsOf: [.scaleFactor(UIScreen.main.scale)])
        
        if let size = downsamplingSize {
            let processor: KingfisherOptionsInfoItem = .processor(DownsamplingImageProcessor(size: size))
            options.append(contentsOf: [processor,
                                        .cacheOriginalImage])
        }
        return options
    }
}
