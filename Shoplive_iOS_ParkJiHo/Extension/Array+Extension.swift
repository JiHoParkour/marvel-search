//
//  Array+Extension.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
