//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct LoginBuilder {
    static func build() -> LoginViewControllerProtocol {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
