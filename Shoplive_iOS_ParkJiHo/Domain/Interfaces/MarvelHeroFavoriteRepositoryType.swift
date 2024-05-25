//
//  MarvelHeroFavoriteRepositoryType.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import RxSwift

enum FavoriteEvent {
    case favorite(FavoriteHero)
    case cancelFavorite(Int)
}

protocol MarvelHeroFavoriteRepositoryType {
    var event: PublishSubject<FavoriteEvent> { get }
    func fetchFavoriteHeros() -> Single<[FavoriteHero]>
    func favoriteHero(hero: FavoriteHero) -> Completable
    func cancelFavoriteHero(heroID: Int) -> Completable
    func cancelOldestFavoriteHero() -> Completable
}
