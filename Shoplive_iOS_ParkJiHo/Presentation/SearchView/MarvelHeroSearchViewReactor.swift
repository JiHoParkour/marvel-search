//
//  MarvelHeroSearchViewReactor.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

import ReactorKit

final class MarvelHeroSearchViewReactor: Reactor {
    enum Action {
        case searchTermChanged(String)
        case loadNextPage
    }
    
    enum Mutation {
        case setSearchTerm(String)
        case setSearchResponse(HeroSearchViewModel)
        case resetSearchResponse
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
        @Pulse var heroCellReactors: [MarvelHeroCellReactor]?
        @Pulse var isLoading: Bool = false
        @Pulse var error: Error?
    }
    
    let initialState: State
    let marvelHeroSearchUseCase: MarvelHeroSearchUseCaseType
    
    init(useCase: MarvelHeroSearchUseCaseType) {
        self.marvelHeroSearchUseCase = useCase
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSearchTerm(let searchTerm):
            state.searchTerm = searchTerm

        case .setSearchResponse(let heroSearch):
            state.heroSearch = heroSearch
            
            let heroCellReactors = state.heroSearch?.heros.map {
                MarvelHeroCellReactor.init(hero: $0)
            }
            
            guard let heroCellReactors else { break }
            state.currentHeroCount == 0 ? state.heroCellReactors = heroCellReactors : state.heroCellReactors?.append(contentsOf: heroCellReactors)
            
        case .resetSearchResponse:
            state.heroCellReactors = nil
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setError(let error):
            state.error = error
        }
        return state
    }
}

extension MarvelHeroSearchViewReactor {
    private func searchMarvelHero(name: String, offset: Int) -> Observable<Mutation> {
        marvelHeroSearchUseCase.seaerch(name: name, offset: offset)
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
