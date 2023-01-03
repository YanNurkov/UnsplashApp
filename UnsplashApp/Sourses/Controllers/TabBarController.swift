//
//  TabBarController.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 02.01.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        setupTabBarViewController()
    }
    
    //MARK: - ConfigurationTabBar
    
    func setupTabBarController() {
        tabBar.tintColor = .white
        tabBar.backgroundColor = .black.withAlphaComponent(0.6)
        tabBar.barTintColor = .black.withAlphaComponent(0.6)
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 30
        tabBar.unselectedItemTintColor = .white
    }
    
    func setupTabBarViewController() {
        let photo = UINavigationController(rootViewController: PhotoViewController())
        let photoIcon = UITabBarItem(title: "Photo", image: UIImage(systemName: "photo"), selectedImage: UIImage(systemName: "photo.fill"))
        photo.tabBarItem = photoIcon
        
        let favoritePhotos = UINavigationController(rootViewController: FavoritesViewController())
        let favoriteIcon = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        favoritePhotos.tabBarItem = favoriteIcon
        
        let controllers  = [photo, favoritePhotos]
        self.setViewControllers(controllers, animated: true)
    }
}

