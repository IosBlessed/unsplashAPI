//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol SettingsViewControllerProtocol: AnyObject {
    var viewModel: SettingsViewModelProtocol! { get set }
    var coordinator: BrowseCoordinatorProtocol! { get set }
}
