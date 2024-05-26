//
//  MarvelHeroSearchViewReactorTests.swift
//  Shoplive_iOS_ParkJiHoTests
//
//  Created by jiho park on 5/25/24.
//

import XCTest
@testable import Shoplive_iOS_ParkJiHo

import RxSwift
import RxTest

final class MarvelHeroSearchViewReactorTests: XCTestCase {
    
    var sutReactor: MarvelHeroSearchViewReactor!
    var marvelHeroSearchRepositor: MarvelHeroSearchRepositoryMock!
    var marvelHeroFavoriteRepository: MarvelHeroFavoriteRepositoryMock!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        marvelHeroSearchRepositor = MarvelHeroSearchRepositoryMock()
        marvelHeroFavoriteRepository = MarvelHeroFavoriteRepositoryMock()
        sutReactor = MarvelHeroSearchViewReactor(
            marvelHeroSearchUseCase: MarvelHeroSearchUseCase(
                marvelHeroSearchRepository: marvelHeroSearchRepositor
            ),
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
    
// MARK: - searchTermChanged
    
    func test_공백_검색시_searchTerm_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged(""))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.searchTerm }.distinctUntilChanged()
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            ""
        ])
    }
    
    func test_1자리_검색시_searchTerm_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("h"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.searchTerm }.distinctUntilChanged()
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil
        ])
    }
    
    func test_1자리_이하_검색시_isLoading_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("h"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.isLoading }.distinctUntilChanged()
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false
        ])
    }
    
    func test_1자리_이하_검색시_heroCellReactors_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("h"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroCellReactors?.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil
        ])
    }
    
    
    func test_1자리_이하_검색시_heroSearch_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("h"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroSearch?.total }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil
        ])
    }
    
    func test_2자리_이상_검색시_searchTerm_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.searchTerm }.distinctUntilChanged()
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            "hulk"
        ])
    }
    
    func test_2자리_이상_검색시_isLoading_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.isLoading }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false,
            true,
            false
        ])
    }
    
    func test_2자리_이상_검색시_heroCellReactors_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroCellReactors?.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            1
        ])
    }
    
    func test_2자리_이상_검색시_heroSearch_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroSearch?.heros.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            1
        ])
    }
    
    func test_2자리_이상_검색시_favoriteHeros_있을때_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.favoriteHeros.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            0,
            5
        ])
    }
    
    func test_2자리_이상_검색시_favoriteHeros_없을때_상태() {
        //given
        marvelHeroFavoriteRepository.shouldSucceed = false
        
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.favoriteHeros.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            0
        ])
    }
    func test_검색_실패시_heroSearch_상태() {
        //given
        marvelHeroSearchRepositor.shouldSucceed = false

        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroSearch?.heros.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil
        ])
    }
    
    func test_검색_실패시_heroCellReactors_상태() {
        //given
        marvelHeroSearchRepositor.shouldSucceed = false

        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk"))
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sutReactor.state.map { $0.heroCellReactors?.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil
        ])
    }
    
    // MARK: - loadNextPage
    
    func test_다음페이지_로드시_isLoading_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk")),
                .next(30, .loadNextPage)
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 20, disposed: 1000) {
            self.sutReactor.state.map { $0.isLoading }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false,
            true,
            false
        ])
    }
    
    func test_다음페이지_로드시_heroCellReactors_상태() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk")),
                .next(30, .loadNextPage)
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 20, disposed: 1000) {
            self.sutReactor.state.map { $0.heroCellReactors?.count }.distinctUntilChanged()
        }

        XCTAssertEqual(response.events.compactMap(\.value.element), [
            1,
            2
        ])
    }
    
    // MARK: - favoriteHero
    
    func test_영웅_좋아요시_favoriteHeroCallCounter_증가() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .favoriteHero(.init(id: 1, name: "", description: "", thumbnailPath: ""))),
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        scheduler.start()

        XCTAssertEqual(marvelHeroFavoriteRepository.favoriteHeroCallCounter, 1)
    }
    
    func test_영웅_6명_이상_좋아요시_cancelOldestFavoriteHeroCallCounter_증가() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .searchTermChanged("hulk")),
                .next(30, .favoriteHero(.init(id: 1, name: "", description: "", thumbnailPath: ""))),
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        scheduler.start()

        XCTAssertEqual(marvelHeroFavoriteRepository.cancelOldestFavoriteHeroCallCounter, 1)
    }
    
    // MARK: - cancelFavoriteHero
    
    func test_영웅_좋아요_취소시_cancelFavoriteHeroCallCounter_증가() {
        //when
        scheduler
            .createHotObservable([
                .next(10, .cancelFavoriteHero(1)),
            ])
            .bind(to: sutReactor.action)
            .disposed(by: disposeBag)
        
        //then
        scheduler.start()

        XCTAssertEqual(marvelHeroFavoriteRepository.cancelFavoriteHeroCallCounter, 1)
    }
}
