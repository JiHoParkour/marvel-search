//
//  ComicsItemDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct ComicsItemDTO: Decodable {
    let resourceURI: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }
}

extension ComicsItemDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}

extension ComicsItemDTO {
    func toDomain() -> ComicsItem {
        .init(resourceURI: resourceURI,
              name: name)
    }
}
