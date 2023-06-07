//
//  LoginBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

struct SettingsBuilder {
    static func build() -> SettingsViewControllerProtocol {
        let container = DependencyManager.shared.appContainer
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel()
        viewController.viewModel = viewModel
        viewController.coordinator = container.resolve(BrowseCoordinatorProtocol.self)
        return viewController
    }
}
