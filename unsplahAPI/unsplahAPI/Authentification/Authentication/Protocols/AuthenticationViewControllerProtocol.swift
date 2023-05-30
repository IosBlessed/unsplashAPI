//
//  AuthenticationViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol AuthenticationViewControllerProtocol: AnyObject {
    var coordinator: AuthentificationCoordinatorProtocol! { get set }
    var viewModel: AuthenticationViewModelProtocol! { get set }
}
