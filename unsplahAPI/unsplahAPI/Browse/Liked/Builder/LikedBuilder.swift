//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct LikedBuilder {
    static func build() -> LikedViewControllerProtocol {
        let viewController = LikedViewController()
        let viewModel = LikedViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
