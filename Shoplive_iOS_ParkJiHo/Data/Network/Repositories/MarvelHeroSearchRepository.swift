//
//  MarvelHeroSearchRepository.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation

import Moya
import RxSwift

final class MarvelHeroSearchRepository: MarvelHeroSearchRepositoryType {
    
    let provider = MoyaProvider<MarvelHeroSearchAPI>()
    var cancellable: Cancellable?

    func search(name: String, offset: Int) -> Single<HeroSearch> {
        let request = HeroSearchRequestDTO(nameStartsWith: name, offset: offset)
        return provider.request(.search(request), responseDataType: HeroSearchDTO.self, completion: { [weak self] cancellable in
            self?.cancellable = cancellable
        })
        .map { $0.toDomain() }
    }
}
