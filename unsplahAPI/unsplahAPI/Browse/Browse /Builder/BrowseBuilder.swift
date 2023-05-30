//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct BrowseBuilder {
    static func build() -> BrowseViewControllerProtocol {
        let viewController = BrowseViewController()
        let viewModel = BrowseViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
