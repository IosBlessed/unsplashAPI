//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct BrowseBuilder {
    static func build() -> BrowseViewControllerProtocol {
        let appContainer = DependencyManager.shared.appContainer
        let viewController = BrowseViewController()
        let viewModel = BrowseViewModel()
        viewController.viewModel = viewModel
        viewController.coordinator = appContainer.resolve(BrowseCoordinatorProtocol.self)
        return viewController
    }
}
