//
//  MainCoordinator.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class MainCoordinator: NSObject, UINavigationControllerDelegate {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coordinator = AuthentificationCoordinator(navigationController: navigationController, mainCoordinator: self)
        coordinator.initializeAuthorizationProcess()
    }
    
    func startBrowse() {
        let coordinator = BrowseCoordinator(navigationController: navigationController, mainCoordinator: self)
        coordinator.initializeBrowseProcess()
    }
}
