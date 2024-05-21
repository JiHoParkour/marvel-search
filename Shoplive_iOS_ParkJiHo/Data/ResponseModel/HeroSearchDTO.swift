//
//  HeroSearchDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct HeroSearchDTO: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let heros: [HeroDTO]
    
    enum CodingKeys: String, CodingKey {
        case offset,limit, total, count
        case heros = "results"
    }
}

extension HeroSearchDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        self.total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        self.count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        self.heros = try container.decodeIfPresent([HeroDTO].self, forKey: .heros) ?? []
    }
}

extension HeroSearchDTO {
    func toDomain() -> HeroSearch {
        .init(offset: offset,
              limit: limit,
              total: total,
              count: count,
              heros: heros.map { $0.toDomain() })
    }
}
