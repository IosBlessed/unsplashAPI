//
//  RootTabBarViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class RootTabBarViewController: UITabBarController, RootTabBarControllerProtocol {
    // MARK: - Lifcyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tabBar.backgroundColor = DesignedSystemColors.primaryContrast
        tabBar.tintColor = .black
        initializeViewControllers()
    }
    // MARK: - Behaviour
    func initializeViewControllers() {
        let likedViewController = LikedBuilder.build() as? LikedViewController
        let browseViewController = BrowseBuilder.build() as? BrowseViewController
        let settingsViewController = SettingsBuilder.build() as? SettingsViewController
        let navigationControllers = [
            includeViewControllerToNavigation(
                for: browseViewController!,
                title: "Browse",
                image: UIImage(systemName: "magnifyingglass")!
            ),
            includeViewControllerToNavigation(
                for: likedViewController!,
                title: "Liked",
                image: UIImage(systemName: "heart")!
            ),
            includeViewControllerToNavigation(
                for: settingsViewController!,
                title: "Settings",
                image: UIImage(systemName: "gear")!
            )
        ]
        viewControllers = navigationControllers
    }

    private func includeViewControllerToNavigation(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

}
