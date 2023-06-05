//
//  AuthenticationBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class AuthentificationCoordinator: AuthentificationCoordinatorProtocol {
    // MARK: - Properties
    unowned var navigationController: UINavigationController
    var mainCoordinator: MainCoordinatorProtocol
    // MARK: - Lifecycle
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinatorProtocol) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    // MARK: - Behaviour
    func initializeAuthorizationProcess() {
        let authentication = AuthenticationBuilder.build()
        authentication.coordinator = self
        self.navigationController.pushViewController(
            (authentication as? AuthenticationViewController) ?? UIViewController(),
            animated: false
        )
    }

    func initializeLoginModule() {
        let loginScreen = LoginBuilder.build() as? LoginViewController
        self.navigationController.pushViewController(loginScreen!, animated: false)
    }

    func initializeCreateAccountModule(isFirstResponder: Bool) {
        let createAccountScreen = CreateAccountBuilder.build() as? CreateAccountViewController
        self.navigationController.pushViewController(createAccountScreen!, animated: isFirstResponder)
    }

    func initializeForgotPasswordModule() {
        let forgotPassword = ForgotPasswordBuilder.build() as? ForgotPasswordViewController
        self.navigationController.pushViewController(forgotPassword!, animated: true)
    }

    func didFinishAuthentification() {
        mainCoordinator.startBrowse()
    }
}
