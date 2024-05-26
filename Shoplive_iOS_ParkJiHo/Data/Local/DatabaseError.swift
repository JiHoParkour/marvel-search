//
//  DatabaseError.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/25/24.
//

import Foundation

enum DatabaseError: Error {
    
    case databaseCreateError
    case tableCreateError(String?)
    case sqliteBindingError(String?)
    case sqlitePrepareFail(String?)
    case sqliteStepFail(String?)
    case tableReadError
    
    var localizedDescription: String {
        switch self {
        case .databaseCreateError:
            NSLocalizedString("Error occurred while creating database", comment: "")
        case .tableCreateError(let message):
            NSLocalizedString("Error occurred while creating table : \(String(describing: message))", comment: "")
        case .sqliteBindingError(let message):
            NSLocalizedString("Error occurred while sqlite binding : \(String(describing: message))", comment: "")
        case .sqlitePrepareFail(let message):
            NSLocalizedString("Error occurred while sqlite prepare : \(String(describing: message))", comment: "")
        case .sqliteStepFail(let message):
            NSLocalizedString("Error occurred while sqlite step : \(String(describing: message))", comment:"")
        case .tableReadError:
            NSLocalizedString("Error occurred while reading table", comment: "")
        }
    }
}
