//
//  MainCoordinator.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class MainCoordinator: NSObject, UINavigationControllerDelegate {
    unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coordinator = AuthentificationCoordinator(navigationController: navigationController)
        coordinator.initializeAuthorizationProcess()
    }
}
