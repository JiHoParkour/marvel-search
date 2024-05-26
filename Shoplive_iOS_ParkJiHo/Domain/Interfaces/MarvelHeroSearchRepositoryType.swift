//
//  MarvelHeroSearchRepositoryType.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import Moya
import RxSwift

protocol MarvelHeroSearchRepositoryType {
    var cancellable: Cancellable? { get }
    func search(name: String, offset: Int) -> Single<HeroSearch>
}
