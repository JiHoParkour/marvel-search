//
//  MarvelHeroCellReactor.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import ReactorKit

final class MarvelHeroCellReactor: Reactor {
    typealias Action = NoAction
    
    enum Mutation {
        case favoriteHero(Int)
        case cancelFavoriteHero(Int)
    }
    
    struct State {
        var hero: HeroViewModel
        var isFavorite: Bool
    }
    
    let initialState: State
    let marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType
    
    init(marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType,
         hero: HeroViewModel,
         isFavorite: Bool) {
        self.marvelHeroFavoriteUseCase = marvelHeroFavoriteUseCase
        initialState = State(hero: hero, isFavorite: isFavorite)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .favoriteHero:
            state.isFavorite = true
            
        case .cancelFavoriteHero:
            state.isFavorite = false
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = marvelHeroFavoriteUseCase.event.flatMap { [weak self] event -> Observable<Mutation> in
            switch event {
            case .favorite(let hero):
                guard hero.id == self?.currentState.hero.id else { return .empty() }
                return .just(.favoriteHero(hero.id))
                
            case .cancelFavorite(let heroID):
                guard heroID == self?.currentState.hero.id else { return .empty() }
                return .just(.cancelFavoriteHero(heroID))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
}
