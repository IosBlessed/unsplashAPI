//
//  AuthenticationBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct AuthenticationBuilder {
    static func build() -> AuthenticationViewControllerProtocol {
        let view = AuthenticationViewController()
        let viewModel = AuthenticationViewModel()
        view.viewModel = viewModel
        return view
    }
}
