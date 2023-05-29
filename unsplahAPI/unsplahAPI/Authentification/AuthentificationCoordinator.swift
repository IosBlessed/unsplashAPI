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
    // MARK: - Lifecycle
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        let loginScreen = LoginBuilder.build() as? LoginViewController ?? LoginViewController()
        loginScreen.coordinator = self
        loginScreen.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(loginScreen, animated: false)
    }
    
    func initializeCreateAccountModule(isFirstResponder: Bool) {
        let createAccountScreen = CreateAccountBuilder.build() as? CreateAccountViewController ?? CreateAccountViewController()
        createAccountScreen.coordinator = self
        createAccountScreen.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(createAccountScreen, animated: isFirstResponder)
    }
    
    func initializeForgotPasswordModule() {
        let forgotPassword = ForgotPasswordBuilder.build() as? ForgotPasswordViewController ?? ForgotPasswordViewController()
        forgotPassword.coordinator = self
        forgotPassword.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(forgotPassword, animated: true)
    }
    
    func didFinishAuthentification() {
        // TODO: realize logic of instantiating of browse module
    }
}
