//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol BrowseViewControllerProtocol: AnyObject {
    var viewModel: BrowseViewModelProtocol! { get set }
    var coordinator: BrowseCoordinatorProtocol! { get set }
}
