//
//  URLElementDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct URLElementDTO: Decodable {
    let type: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case type, url
    }
}

extension URLElementDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}

extension URLElementDTO {
    func toDomain() -> URLElement {
        .init(type: type,
              url: url)
    }
}
