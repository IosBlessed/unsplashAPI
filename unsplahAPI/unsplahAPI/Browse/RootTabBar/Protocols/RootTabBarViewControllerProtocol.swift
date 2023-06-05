//
//  LoginViewControllerProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation

protocol RootTabBarControllerProtocol: AnyObject {
    var coordinator: BrowseCoordinatorProtocol! { get set }
    func initializeViewControllers()
}
