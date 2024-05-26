//
//  NetworkError.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation

import Moya

enum NetworkError: Error {

    case clientError
    case decodingError
    case unknwon
    
    var localizedDescription: String {
        switch self {
        case .clientError:
            NSLocalizedString("Client error occurred", comment: "")
        case .decodingError:
            NSLocalizedString("Decoding error occurred", comment: "")
        case .unknwon:
            NSLocalizedString("Unknwon error occurred", comment: "")
        }
    }
}
