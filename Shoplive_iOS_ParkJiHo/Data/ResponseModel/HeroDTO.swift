//
//  ResultDTO.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Foundation

struct HeroDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: ThumbnailDTO
    let resourceURI: String
    let comics: ComicsDTO
    let series: ComicsDTO
    let stories: StoriesDTO
    let events: ComicsDTO
    let urls: [URLElementDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

extension HeroDTO {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.modified = try container.decodeIfPresent(String.self, forKey: .modified) ?? ""
        self.thumbnail = try container.decode(ThumbnailDTO.self, forKey: .thumbnail)
        self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI) ?? ""
        self.comics = try container.decode(ComicsDTO.self, forKey: .comics)
        self.series = try container.decode(ComicsDTO.self, forKey: .series)
        self.stories = try container.decode(StoriesDTO.self, forKey: .stories)
        self.events = try container.decode(ComicsDTO.self, forKey: .events)
        self.urls = try container.decode([URLElementDTO].self, forKey: .urls)
        
    }
}

extension HeroDTO {
    func toDomain() -> Hero {
        .init(id: id,
              name: name,
              description: description,
              modified: modified,
              thumbnail: thumbnail.toDomain(),
              resourceURI: resourceURI,
              comics: comics.toDomain(),
              series: series.toDomain(),
              stories: stories.toDomain(),
              events: events.toDomain(),
              urls: urls.map { $0.toDomain() })
    }
}
