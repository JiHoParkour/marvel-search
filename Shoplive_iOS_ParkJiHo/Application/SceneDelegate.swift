//
//  SceneDelegate.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/20/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureTabBar(with: windowScene)
    }
    
    private func configureTabBar(with windowScene: UIWindowScene) {
        
        let marvelHeroFavoriteUseCase = MarvelHeroFavoriteUseCase(marvelHeroFavoriteRepository: MarvelHeroFavoriteRepository())
        let heroSearchViewController = MarvelHeroSearchViewController()
        let heroSearchViewReactor = MarvelHeroSearchViewReactor(
            marvelHeroSearchUseCase: MarvelHeroSearchUseCase(marvelHeroSearchRepository: MarvelHeroSearchRepository()),
            marvelHeroFavoriteUseCase: marvelHeroFavoriteUseCase)
        heroSearchViewController.reactor = heroSearchViewReactor
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchTabBarItem = UITabBarItem(title: "SEARCH", image: searchImage, selectedImage: nil)
        heroSearchViewController.tabBarItem = searchTabBarItem
        
        let favoriteHeroListViewController = FavoriteHeroListViewController()
        let favoriteHeroListViewReactor = FavoriteHeroListViewReactor(marvelHeroFavoriteUseCase: marvelHeroFavoriteUseCase)
        favoriteHeroListViewController.reactor = favoriteHeroListViewReactor
        let favoriteImage = UIImage(systemName: "heart.fill")
        let favoriteTabBarItem = UITabBarItem(title: "FAVORITE", image: favoriteImage, selectedImage: nil)
        favoriteHeroListViewController.tabBarItem = favoriteTabBarItem
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.setViewControllers([heroSearchViewController, favoriteHeroListViewController], animated: false)
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        self.window = window
        window.makeKeyAndVisible()
        window.rootViewController = tabBarController
    }
}
