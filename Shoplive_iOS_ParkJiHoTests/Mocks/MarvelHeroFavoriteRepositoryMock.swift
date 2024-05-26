//
//  MarvelHeroFavoriteRepositoryMock.swift
//  Shoplive_iOS_ParkJiHoTests
//
//  Created by jiho park on 5/25/24.
//

@testable import Shoplive_iOS_ParkJiHo
import Foundation

import RxSwift

final class MarvelHeroFavoriteRepositoryMock: MarvelHeroFavoriteRepositoryType {
    var event = PublishSubject<FavoriteEvent>()
    var shouldSucceed: Bool = true
    func fetchFavoriteHeros() -> Single<[FavoriteHero]> {
        return Single.create { single in
            if self.shouldSucceed {
                single(.success([.init(id: 1, name: "", description: "", thumbnailPath: ""),
                                 .init(id: 1, name: "", description: "", thumbnailPath: ""),
                                 .init(id: 1, name: "", description: "", thumbnailPath: ""),
                                 .init(id: 1, name: "", description: "", thumbnailPath: ""),
                                 .init(id: 1, name: "", description: "", thumbnailPath: "")]))
            } else {
                single(.failure(NSError(domain: "MarvelHeroFavoriteRepositoryMock", code: 0, userInfo: nil)))
            }
            return Disposables.create()
        }
    }
    
    var favoriteHeroCallCounter = 0
    func favoriteHero(hero: FavoriteHero) -> Completable {
        favoriteHeroCallCounter += 1
        return Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }
    
    var cancelFavoriteHeroCallCounter = 0
    func cancelFavoriteHero(heroID: Int) -> Completable {
        cancelFavoriteHeroCallCounter += 1
        return Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }
    
    var cancelOldestFavoriteHeroCallCounter = 0
    func cancelOldestFavoriteHero() -> Completable {
        cancelOldestFavoriteHeroCallCounter += 1
        return Completable.create { completable in
            completable(.completed)
            return Disposables.create()
        }
    }
}
