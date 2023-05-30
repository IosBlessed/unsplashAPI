//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

struct RootTabBarBuilder {
    static func build() -> RootTabBarControllerProtocol {
        let tabBarController = RootTabBarViewController()
        tabBarController.selectedIndex = 1
        tabBarController.modalPresentationStyle = .fullScreen
        return tabBarController
    }
}
