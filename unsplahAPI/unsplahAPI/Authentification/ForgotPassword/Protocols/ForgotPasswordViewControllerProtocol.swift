//
//  ForgotPasswordViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol ForgotPasswordViewControllerProtocol: AnyObject {
    var viewModel: ForgotPasswordViewModelProtocol! { get set }
    var coordinator: AuthentificationCoordinatorProtocol! { get set }
}
