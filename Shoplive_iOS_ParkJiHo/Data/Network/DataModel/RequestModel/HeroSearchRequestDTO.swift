//
//  HeroSearchRequestDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation
struct HeroSearchRequestDTO: Encodable {
    let ts: Int = 1
    let limit: Int = 10
    let apiKey: String = Environment.value(forKey: .MarvelAPIKey)
    let hash: String = Environment.value(forKey: .MarvelAPIHash)
    let nameStartsWith: String
    let offset: Int
}
