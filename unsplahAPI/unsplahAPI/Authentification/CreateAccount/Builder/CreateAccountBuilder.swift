//
//  CreateAccountBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation

struct CreateAccountBuilder {
    static func build() -> CreateAccountViewControllerProtocol {
        let viewController = CreateAccountViewController()
        let viewModel = CreateAccountViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
