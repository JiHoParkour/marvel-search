//
//  ResultViewModel.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct HeroViewModel {
    let id: Int
    let name: String
    let description: String
    let thumbnailPath: String
    let isFavorite: Bool = false
}

extension HeroViewModel {
    init(with hero: Hero) {
        self.id = hero.id
        self.name = hero.name
        self.description = hero.description
        
        if hero.thumbnail.path.contains("http://") {
            self.thumbnailPath = hero.thumbnail.path.replacingOccurrences(of: "http://", with: "https://") + "." + hero.thumbnail.thumbnailExtension
        } else {
            self.thumbnailPath = hero.thumbnail.path + "." + hero.thumbnail.thumbnailExtension
        }
    }
}
