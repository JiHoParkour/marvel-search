//
//  HeroSearchViewModel.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct HeroSearchViewModel {
    let total: Int
    let heros: [HeroViewModel]
}

extension HeroSearchViewModel {
    init(with heroSearch: HeroSearch) {
        self.total = heroSearch.total
        self.heros = heroSearch.heros.map { .init(with: $0) }
    }
}
