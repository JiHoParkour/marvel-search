//
//  FavoriteHeroListViewReactor.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import ReactorKit

final class FavoriteHeroListViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case cancelFavoriteHero(Int)
    }
    
    enum Mutation {
        case setFavoriteHeros([FavoriteHero])
        case addFavoriteHero(FavoriteHero)
        case deleteFavoriteHero(Int)
        case setError(Error)
    }
    
    struct State {
        @Pulse var heroCellReactors: [MarvelHeroCellReactor]?
        @Pulse var error: Error?
    }
    
    let initialState: State
    let marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType
    
    init(marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType) {
        self.marvelHeroFavoriteUseCase = marvelHeroFavoriteUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchFavoriteHeros()
        case .cancelFavoriteHero(let heroID):
            return cancelFavoriteHero(heroID: heroID)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setFavoriteHeros(let favoriteHeros):
            state.heroCellReactors = favoriteHeros.map { hero in
                .init(
                    marvelHeroFavoriteUseCase: marvelHeroFavoriteUseCase,
                    hero: .init(
                        id: hero.id,
                        name: hero.name,
                        description: hero.description ?? "",
                        thumbnailPath: hero.thumbnailPath ?? ""
                    ),
                    isFavorite: true
                )
            }
            
        case .addFavoriteHero(let hero):
            state.heroCellReactors?.append(
                .init(
                    marvelHeroFavoriteUseCase: marvelHeroFavoriteUseCase,
                    hero: .init(
                        id: hero.id,
                        name: hero.name,
                        description: hero.description ?? "",
                        thumbnailPath: hero.thumbnailPath ?? ""
                    ),
                    isFavorite: true
                )
            )
            
        case .deleteFavoriteHero(let heroID):
            state.heroCellReactors?.removeAll(where: { $0.currentState.hero.id == heroID })
        
        case .setError(let error):
            state.error = error
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = marvelHeroFavoriteUseCase.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .favorite(let hero):
                return .just(.addFavoriteHero(hero))
            
            case .cancelFavorite(let heroID):
                return .just(.deleteFavoriteHero(heroID))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
}


// MARK: - FavoriteHero

extension FavoriteHeroListViewReactor {
    private func fetchFavoriteHeros() -> Observable<Mutation> {
        marvelHeroFavoriteUseCase.fetchFavoriteHeros()
            .asObservable()
            .flatMap { favoriteHeros -> Observable<Mutation> in
                return .just(.setFavoriteHeros(favoriteHeros))
            }
            .catch { error in
                    .just(.setError(error))
            }
    }
    
    private func cancelFavoriteHero(heroID: Int) -> Observable<Mutation> {
        marvelHeroFavoriteUseCase.cancelFavoriteHero(heroID: heroID)
        .asObservable()
        .flatMap { _ -> Observable<Mutation> in }
        .catch { error in
                .just(.setError(error))
        }
    }
}
