//
//  MarvelHeroSearchUseCase.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import RxSwift

protocol MarvelHeroSearchUseCaseType {
    func search(name: String, offset: Int) -> Single<HeroSearch>
}

final class MarvelHeroSearchUseCase: MarvelHeroSearchUseCaseType {

    private let marvelHeroSearchRepository: MarvelHeroSearchRepositoryType
    
    init(marvelHeroSearchRepository: MarvelHeroSearchRepositoryType) {
        self.marvelHeroSearchRepository = marvelHeroSearchRepository
    }
    
    func search(name: String, offset: Int) -> Single<HeroSearch> {
        return marvelHeroSearchRepository.search(name: name, offset: offset)
    }
}
