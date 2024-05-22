//
//  MarvelHeroSearchAPI.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation

import Moya

enum MarvelHeroSearchAPI {
    case search(HeroSearchRequestDTO)
}

extension MarvelHeroSearchAPI: TargetType {

    var baseURL: URL {
        guard let url = URL(string: Environment.value(forKey: .baseURL)) else { fatalError() }
        return url
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }

    var path: String {
        switch self {
        case .search:
            return "characters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .search(let request):
            return .requestParameters(parameters: ["ts": request.ts,
                                                   "limit": request.limit,
                                                   "apikey": request.apiKey,
                                                   "hash": request.hash,
                                                   "offset": request.offset,
                                                   "nameStartsWith": request.nameStartsWith], encoding: URLEncoding.default)
        }
    }
}
