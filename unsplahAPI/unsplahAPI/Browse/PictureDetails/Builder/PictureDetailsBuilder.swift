//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation

struct PictureDetailsBuilder {
    static func build() -> PictureDetailsViewControllerProtocol {
        let viewController = PictureDetailsViewController()
        let viewModel = PictureDetailsViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
