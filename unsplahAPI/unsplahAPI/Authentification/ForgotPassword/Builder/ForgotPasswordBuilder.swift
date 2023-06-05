//
//  ForgotPasswordBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct ForgotPasswordBuilder {
    static func build() -> ForgotPasswordViewControllerProtocol {
        let viewController = ForgotPasswordViewController()
        let viewModel = ForgotPasswordViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
