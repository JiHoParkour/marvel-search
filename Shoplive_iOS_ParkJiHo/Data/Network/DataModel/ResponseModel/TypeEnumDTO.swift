//
//  TypeEnumDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

enum TypeEnumDTO: String, Decodable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

extension TypeEnumDTO {
    func toDomain() -> TypeEnum {
        switch self {
        case .cover: .cover
        case .interiorStory: .interiorStory
        }
    }
}
