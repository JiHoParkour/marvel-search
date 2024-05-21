//
//  MarvelHeroSearchRepositoryType.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/21/24.
//

import RxSwift

protocol MarvelHeroSearchRepositoryType {
    func searchMarvelHero(name: String, offset: Int) -> Single<HeroSearch>
}
