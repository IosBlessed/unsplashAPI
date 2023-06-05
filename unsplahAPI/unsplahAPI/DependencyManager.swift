//
//  DependencyManager.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 03.06.2023.
//

import Foundation
import UIKit
import Swinject

class DependencyManager {
    // MARK: - Properties
    let appContainer = Container()
    // MARK: - Singleton
    static let shared = DependencyManager()
    private init() {}
    // MARK: - Lifecycle
    func assemblyDependencies() {
        self.initializeMainCoordinatorInjections()
        self.initializeAuthentificationCoordinatorInjections()
        self.initializeBrowseCoordinatorInjections()
    }
    
    private func initializeMainCoordinatorInjections() {
        appContainer.register(MainCoordinatorProtocol.self) { _ in
            let navigationController = UINavigationController()
            return MainCoordinator(navigationController: navigationController)
        }.inObjectScope(.container)
    }
    // MARK: - Authentification Module
    private func initializeAuthentificationCoordinatorInjections() {
        appContainer.register(AuthentificationCoordinatorProtocol.self) { moduleResolver in
            guard let mainCoordinator = moduleResolver.resolve(MainCoordinatorProtocol.self)
            else { fatalError("Incorrect injection of Main Coordinator") }
            return AuthentificationCoordinator(
                navigationController: mainCoordinator.navigationController,
                mainCoordinator: mainCoordinator
            )
        }.inObjectScope(.container)
    }
    
    // MARK: - Browse Module
    private func initializeBrowseCoordinatorInjections() {
        appContainer.register(BrowseCoordinatorProtocol.self) { moduleResolver in
            guard let mainCoordinator = moduleResolver.resolve(MainCoordinatorProtocol.self)
            else { fatalError("Incorrect injection of Main Coordinator") }
            return BrowseCoordinator(
                navigationController: mainCoordinator.navigationController,
                mainCoordinator: mainCoordinator
            )
        }.inObjectScope(.container)
    }
}
