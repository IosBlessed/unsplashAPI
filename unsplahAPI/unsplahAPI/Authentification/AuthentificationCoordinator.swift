//
//  AuthenticationBuilder.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class AuthentificationCoordinator: AuthentificationCoordinatorProtocol {
    
    unowned var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func initializeAuthorizationProcess() {
        let authentication = AuthenticationBuilder.build()
        authentication.coordinator = self
        self.navigationController.pushViewController(authentication as! AuthenticationViewController, animated: false)
    }
    
    func didFinishAuthentification() {
        //TODO: realize logic of instantiating of browse module
    }
}
