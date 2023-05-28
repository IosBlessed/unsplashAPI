//
//  AuthenticationBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class AuthentificationCoordinator: AuthentificationCoordinatorProtocol {

    unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

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
        loginScreen?.coordinator = self 
        loginScreen?.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(loginScreen!, animated: false)
    }
    
    func initializeCreateAccountModule() {
        let createAccountScreen = CreateAccountBuilder.build() as? CreateAccountViewController
        createAccountScreen?.coordinator = self
        createAccountScreen?.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(createAccountScreen!, animated: true)
    }
    
    func didFinishAuthentification() {
        // TODO: realize logic of instantiating of browse module
    }
}
