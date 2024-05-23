//
//  StoriesDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct StoriesDTO: Decodable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItemDTO]
    let returned: Int
    
    enum CodingKeys: String, CodingKey {
        case available, collectionURI, items, returned
    }
}

extension StoriesDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.available = try container.decodeIfPresent(Int.self, forKey: .available) ?? 0
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI) ?? ""
        self.items = try container.decode([StoriesItemDTO].self, forKey: .items)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned) ?? 0
    }
}

extension StoriesDTO {
    func toDomain() -> Stories {
        .init(available: available,
              collectionURI: collectionURI,
              items: items.map { $0.toDomain() },
              returned: returned)
    }
}

