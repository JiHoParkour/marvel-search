//
//  StoriesItemDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct StoriesItemDTO: Decodable {
    let resourceURI: String
    let name: String
    let type: TypeEnumDTO?
    
    enum CodingKeys: String, CodingKey {
        case resourceURI, name, type
    }
}

extension StoriesItemDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.type = try? container.decode(TypeEnumDTO.self, forKey: .type)
    }
}

extension StoriesItemDTO {
    func toDomain() -> StoriesItem {
        .init(resourceURI: resourceURI,
              name: name,
              type: type?.toDomain() ?? .none)
    }
}
