//
//  FavoriteHeroListViewReactorTests.swift
//  Shoplive_iOS_ParkJiHoTests
//
//  Created by jiho park on 5/26/24.
//

import XCTest
@testable import Shoplive_iOS_ParkJiHo

import RxSwift
import RxTest

final class FavoriteHeroListViewReactorTests: XCTestCase {
    
    var sutReactor: FavoriteHeroListViewReactor!
    var marvelHeroFavoriteRepository: MarvelHeroFavoriteRepositoryMock!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        marvelHeroFavoriteRepository = MarvelHeroFavoriteRepositoryMock()
        sutReactor = FavoriteHeroListViewReactor(
            marvelHeroFavoriteUseCase: MarvelHeroFavoriteUseCase(
                marvelHeroFavoriteRepository: marvelHeroFavoriteRepository
            )
        )
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        sutReactor = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    // MARK: - viewDidLoad
    
    func test_viewDidLoad시_heroCellReactors_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .viewDidLoad)
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroCellReactors?.count }.distinctUntilChanged()
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            5
        ])
    }
    
    // MARK: - cancelFavoriteHero
    
    func test_영웅_좋아요_취소시_cancelFavoriteHeroCallCounter_증가() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .cancelFavoriteHero(1))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        scheduler.start()
        
        XCTAssertEqual(marvelHeroFavoriteRepository.cancelFavoriteHeroCallCounter, 1)
    }
}
