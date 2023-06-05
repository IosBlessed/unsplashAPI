//
//  MainCoordinator.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit
import Swinject

final class MainCoordinator: NSObject, UINavigationControllerDelegate, MainCoordinatorProtocol {
    var navigationController: UINavigationController
    private let container: Container = DependencyManager.shared.appContainer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func initialStart() {
        guard let coordinator = container.resolve(AuthentificationCoordinatorProtocol.self)
        else { fatalError("Incorrect resolve of Auth Coordinator") }
        coordinator.initializeAuthorizationProcess()
    }

    func startBrowse() {
        guard let coordinator = container.resolve(BrowseCoordinatorProtocol.self)
        else { fatalError("Incorrect resolve of Browse Coordinator") }
        coordinator.initializeBrowseProcess()
    }
}
