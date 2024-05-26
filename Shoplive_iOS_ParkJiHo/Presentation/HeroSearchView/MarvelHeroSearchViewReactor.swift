//
//  MarvelHeroSearchViewReactor.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import ReactorKit

final class MarvelHeroSearchViewReactor: Reactor {
    enum Action {
        case searchTermChanged(String)
        case loadNextPage
        case favoriteHero(HeroViewModel)
        case cancelFavoriteHero(Int)
    }
    
    enum Mutation {
        case setSearchTerm(String)
        case setSearchResponse(HeroSearchViewModel)
        case resetSearchResponse
        case setFavoriteHeros([FavoriteHero])
        case addFavoriteHero(FavoriteHero)
        case deleteFavoriteHero(Int)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var searchTerm: String?
        var heroSearch: HeroSearchViewModel?
        var currentHeroCount: Int {
            return heroCellReactors?.count ?? 0
        }
        var hasNextPage: Bool {
            guard let totalCount = heroSearch?.total else { return false }
            return totalCount > currentHeroCount
        }
        var favoriteHeros: [FavoriteHero] = []
        var favoriteHeroCount: Int {
            favoriteHeros.count
        }
        @Pulse var heroCellReactors: [MarvelHeroCellReactor]?
        @Pulse var isLoading: Bool = false
        @Pulse var error: Error?
    }
    
    let initialState: State
    let marvelHeroSearchUseCase: MarvelHeroSearchUseCaseType
    let marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType
    
    init(marvelHeroSearchUseCase: MarvelHeroSearchUseCaseType,
         marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCaseType) {
        self.marvelHeroSearchUseCase = marvelHeroSearchUseCase
        self.marvelHeroFavoriteUseCase = marvelHeroFavoriteUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchTermChanged(let searchTerm):
            if searchTerm.isEmpty {
                return .concat(.just(.setSearchTerm(searchTerm)),
                               .just(.resetSearchResponse)
                )
            }
            
            guard searchTerm.count >= 2 else { return .empty() }
            
            return .concat(.just(.setLoading(true)),
                           .just(.setSearchTerm(searchTerm)),
                           .just(.resetSearchResponse),
                           fetchFavoriteHeros(),
                           searchMarvelHero(name: searchTerm, offset: 0),
                           .just(.setLoading(false))
            )
            
        case .loadNextPage:
            guard currentState.hasNextPage,
                  currentState.isLoading == false,
                  let searchTerm = currentState.searchTerm
            else {
                return .empty()
            }
            return .concat(.just(.setLoading(true)),
                           searchMarvelHero(name: searchTerm, offset: currentState.currentHeroCount),
                           .just(.setLoading(false))
            )
            
        case .favoriteHero(let hero):
            let deleteExceedFour: Observable<Mutation> = currentState.favoriteHeroCount > 4 ? self.cancelOldestFavoriteHero() : .empty()

            return .concat(deleteExceedFour,
                           favoriteHero(hero: hero))
            
        case .cancelFavoriteHero(let heroID):
            return cancelFavoriteHero(heroID: heroID)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSearchTerm(let searchTerm):
            state.searchTerm = searchTerm
            
        case .setSearchResponse(let heroSearch):
            state.heroSearch = heroSearch
            
            let heroCellReactors = state.heroSearch?.heros.map { hero in
                MarvelHeroCellReactor.init(
                    marvelHeroFavoriteUseCase: self.marvelHeroFavoriteUseCase,
                    hero: hero,
                    isFavorite: state.favoriteHeros.map { $0.id }.contains { $0 == hero.id }
                )
            }
            
            guard let heroCellReactors else { break }
            state.currentHeroCount == 0 ? state.heroCellReactors = heroCellReactors : state.heroCellReactors?.append(contentsOf: heroCellReactors)
            
        case .setFavoriteHeros(let favoriteHeros):
            state.favoriteHeros = favoriteHeros
            
        case .resetSearchResponse:
            state.heroCellReactors = nil
            
        case .addFavoriteHero(let hero):
            state.favoriteHeros.append(hero)
            
        case .deleteFavoriteHero(let heroID):
            state.favoriteHeros.removeAll {
                $0.id == heroID
            }
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
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

// MARK: - SearchHero

extension MarvelHeroSearchViewReactor {
    private func searchMarvelHero(name: String, offset: Int) -> Observable<Mutation> {
        marvelHeroSearchUseCase.cancellable?.cancel()
        return marvelHeroSearchUseCase.search(name: name, offset: offset)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                let heroSearchViewModel = HeroSearchViewModel(with: response)
                return .just(.setSearchResponse(heroSearchViewModel))
            }
            .catch { error in
                    .just(.setError(error))
            }
    }
}

// MARK: - FavoriteHero

extension MarvelHeroSearchViewReactor {
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
    
    private func favoriteHero(hero: HeroViewModel) -> Observable<Mutation> {
        marvelHeroFavoriteUseCase.favoriteHero(
            hero: .init(
                id: hero.id,
                name: hero.name,
                description: hero.description,
                thumbnailPath: hero.thumbnailPath
            )
        )
        .asObservable()
        .flatMap { _ -> Observable<Mutation> in }
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
    
    private func cancelOldestFavoriteHero() -> Observable<Mutation> {
        marvelHeroFavoriteUseCase.cancelOldestFavoriteHero()
        .asObservable()
        .flatMap { _ -> Observable<Mutation> in }
        .catch { error in
                .just(.setError(error))
        }
    }
}
