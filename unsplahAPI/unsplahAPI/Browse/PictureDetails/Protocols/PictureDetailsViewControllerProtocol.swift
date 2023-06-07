//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation

protocol PictureDetailsViewControllerProtocol: AnyObject {
    var viewModel: PictureDetailsViewModelProtocol! { get set }
    func initializeImageSetup(image: UnsplashImage)
}
