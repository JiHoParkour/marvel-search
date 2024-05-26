//
//  MarvelHeroSearchRepositoryMock.swift
//  Shoplive_iOS_ParkJiHoTests
//
//  Created by jiho park on 5/26/24.
//

@testable import Shoplive_iOS_ParkJiHo
import Foundation

import RxSwift

final class MarvelHeroSearchRepositoryMock: MarvelHeroSearchRepositoryType {
    var shouldSucceed: Bool = true
    func search(name: String, offset: Int) -> Single<HeroSearch> {
        return Single.create { [unowned self] single in
            if self.shouldSucceed {
                single(.success(.init(offset: 0, limit: 1, total: 10, count: 1, heros: [.init(id: 1, name: "", description: "", modified: "", thumbnail: .init(path: "", thumbnailExtension: ""), resourceURI: "", comics: .init(available: 1, collectionURI: "", items: [], returned: 1), series: .init(available: 1, collectionURI: "", items: [], returned: 1), stories: .init(available: 0, collectionURI: "", items: [], returned: 1), events: .init(available: 0, collectionURI: "", items: [], returned: 1), urls: [])])))
            } else {
                single(.failure(NSError(domain: "MarvelHeroSearchRepositoryMock", code: 0, userInfo: nil)))
            }
            return Disposables.create()
        }
    }
}
