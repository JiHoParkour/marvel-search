//
//  HeroFavoriteRepository.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/25/24.
//

import RxSwift

final class MarvelHeroFavoriteRepository: MarvelHeroFavoriteRepositoryType {
    
    private let dbManager = FavoriteHeroDatabaseManager.shared
    let event = PublishSubject<FavoriteEvent>()
    
    init() {
        do {
            try dbManager.createTable()
        } catch(let error) {
            fatalError("Error occurred while creating favoriteHero database table: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoriteHeros() -> Single<[FavoriteHero]> {
        return Single.create { [weak self] single in
            do {
                let favoriteHeros = try self?.dbManager.readFavoriteHeros()
                
                if let favoriteHeros {
                    single(.success(favoriteHeros))
                } else {
                    single(.failure(DatabaseError.tableReadError))
                }
            } catch (let error){
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func favoriteHero(hero: FavoriteHero) -> Completable {
        return Completable.create { [weak self] completable in
            do {
                if let favoritedHero = try self?.dbManager.insertFavoriteHero(heroID: hero.id,
                                                                              name: hero.name,
                                                                              description: hero.description ?? "",
                                                                              thumbnailPath: hero.thumbnailPath ?? "") {
                    self?.event.onNext(.favorite(favoritedHero))
                }
                completable(.completed)
            } catch (let error){
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func cancelFavoriteHero(heroID: Int) -> Completable {
        return Completable.create { [weak self] completable in
            do {
                if let canceledHeroID = try self?.dbManager.deleteFavoriteHero(with: heroID) {
                    self?.event.onNext(.cancelFavorite(canceledHeroID))
                }
                completable(.completed)
            } catch (let error){
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func cancelOldestFavoriteHero() -> Completable {
        return Completable.create { [weak self] completable in
            do {
                if let canceledHeroID = try self?.dbManager.deleteOldestFavoriteHero() {
                    self?.event.onNext(.cancelFavorite(canceledHeroID))
                }
                completable(.completed)
            } catch (let error){
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
