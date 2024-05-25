//
//  MarvelHeroFavoriteUseCase.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import RxSwift

protocol MarvelHeroFavoriteUseCaseType {
    var event: PublishSubject<FavoriteEvent> { get }
    func fetchFavoriteHeros() -> Single<[FavoriteHero]>
    func favoriteHero(hero: FavoriteHero) -> Completable
    func cancelFavoriteHero(heroID: Int) -> Completable
    func cancelOldestFavoriteHero() -> Completable
}

final class MarvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType {
    
    private let marvelHeroFavoriteRepository: MarvelHeroFavoriteRepositoryType

    init(marvelHeroFavoriteRepository: MarvelHeroFavoriteRepositoryType) {
        self.marvelHeroFavoriteRepository = marvelHeroFavoriteRepository
    }
    
    var event: PublishSubject<FavoriteEvent> {
        marvelHeroFavoriteRepository.event
    }
    
    func fetchFavoriteHeros() -> Single<[FavoriteHero]> {
        marvelHeroFavoriteRepository.fetchFavoriteHeros()
    }
    
    func favoriteHero(hero: FavoriteHero) -> Completable {
        marvelHeroFavoriteRepository.favoriteHero(hero: hero)
    }
    
    func cancelFavoriteHero(heroID: Int) -> Completable {
        marvelHeroFavoriteRepository.cancelFavoriteHero(heroID: heroID)
    }
    
    func cancelOldestFavoriteHero() -> Completable {
        marvelHeroFavoriteRepository.cancelOldestFavoriteHero()
    }
}
