//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol LoginViewControllerProtocol: AnyObject {
    var viewModel: LoginViewModelProtocol? { get set }
    var coordinator: AuthentificationCoordinatorProtocol? { get set }
}
