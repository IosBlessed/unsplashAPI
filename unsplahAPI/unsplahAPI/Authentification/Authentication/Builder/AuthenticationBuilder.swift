//
//  AuthenticationBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct AuthenticationBuilder {
    static func build() -> AuthenticationViewControllerProtocol {
        let viewController = AuthenticationViewController()
        let viewModel = AuthenticationViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
