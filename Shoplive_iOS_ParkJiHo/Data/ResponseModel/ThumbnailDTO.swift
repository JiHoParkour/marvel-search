//
//  ThumbnailDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct ThumbnailDTO: Decodable {
    let path: String
    let thumbnailExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

extension ThumbnailDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
        self.thumbnailExtension = try container.decodeIfPresent(String.self, forKey: .thumbnailExtension) ?? ""
    }
}

extension ThumbnailDTO {
    func toDomain() -> Thumbnail {
        .init(path: path,
              thumbnailExtension: thumbnailExtension)
    }
}
