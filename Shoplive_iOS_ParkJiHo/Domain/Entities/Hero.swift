//
//  Result.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct Hero {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: Comics
    let series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]
}
