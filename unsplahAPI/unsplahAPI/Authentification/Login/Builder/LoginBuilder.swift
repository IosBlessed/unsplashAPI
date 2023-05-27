//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct LoginBuilder {
    static func build() -> LoginViewControllerProtocol {
        let loginVC = LoginViewController()
        let viewModel = LoginViewModel()
        loginVC.viewModel = viewModel
        return loginVC
    }
}
