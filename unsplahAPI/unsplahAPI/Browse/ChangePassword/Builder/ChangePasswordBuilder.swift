//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct ChangePasswordBuilder {
    static func build() -> ChangePasswordViewControllerProtocol {
        let viewController = ChangePasswordViewController()
        let viewModel = ChangePasswordViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
