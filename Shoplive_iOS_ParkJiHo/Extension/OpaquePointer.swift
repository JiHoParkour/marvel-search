//
//  OpaquePointer.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/25/24.
//

import SQLite3

extension OpaquePointer {
    var errorMessage: String {
        String(cString: sqlite3_errmsg(self))
    }
}
