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
    }
    
    struct State {
        var hero: HeroViewModel
    }
    
    let initialState: State
    
    init(hero: HeroViewModel) {
        initialState = State(hero: hero)
    }
}
