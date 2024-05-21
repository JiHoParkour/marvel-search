//
//  HeroSearchViewModel.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct HeroSearchViewModel {
    let offset: Int
    let total: Int
    let count: Int
    let heros: [HeroViewModel]
}

extension HeroSearchViewModel {
    init(with heroSearch: HeroSearch) {
        self.offset = heroSearch.offset
        self.total = heroSearch.total
        self.count = heroSearch.count
        self.heros = heroSearch.heros.map { .init(with: $0) }
    }
}
