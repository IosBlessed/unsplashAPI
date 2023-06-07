//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol LikedViewControllerProtocol: AnyObject {
    var viewModel: LikedViewModelProtocol! { get set }
    var coordinator: BrowseCoordinatorProtocol! { get set }
}
