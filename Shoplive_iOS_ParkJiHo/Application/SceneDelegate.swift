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
        let vc = MarvelHeroSearchViewController()
        let reactor = MarvelHeroSearchViewReactor()
        vc.reactor = reactor
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchTabBarItem = UITabBarItem(title: "SEARCH", image: searchImage, selectedImage: nil)
        vc.tabBarItem = searchTabBarItem
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([vc], animated: false)
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        self.window = window
        window.makeKeyAndVisible()
        window.rootViewController = tabBarController
    }
}
