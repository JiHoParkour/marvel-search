//
//  MarvelHeroSearchUseCase.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import RxSwift

protocol MarvelHeroSearchUseCaseType {
    func seaerchMarvelHero(name: String, offset: Int) -> Single<HeroSearch>
}

final class MarvelHeroSearchUseCase: MarvelHeroSearchUseCaseType {

    private let marvelHeroSearchRepository: MarvelHeroSearchRepositoryType
    
    init(marvelHeroSearchRepository: MarvelHeroSearchRepositoryType) {
        self.marvelHeroSearchRepository = marvelHeroSearchRepository
    }
    
    func seaerchMarvelHero(name: String, offset: Int) -> Single<HeroSearch> {
        return marvelHeroSearchRepository.searchMarvelHero(name: name, offset: offset)
    }
}
