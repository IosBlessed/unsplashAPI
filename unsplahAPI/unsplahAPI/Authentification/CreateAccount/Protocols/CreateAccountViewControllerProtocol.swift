//
//  CreateAccountViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol CreateAccountViewControllerProtocol: AnyObject {
    var viewModel: CreateAccountViewModelProtocol? { get set }
    var coordinator: AuthentificationCoordinatorProtocol? { get set }
}
