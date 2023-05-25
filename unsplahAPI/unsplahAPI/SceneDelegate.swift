//
//  SceneDelegate.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

