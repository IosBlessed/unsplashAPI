//
//  AuthentificationCoordinatorProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
import UIKit
protocol AuthentificationCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    var mainCoordinator: MainCoordinatorProtocol { get set }
    func initializeAuthorizationProcess()
    func initializeLoginModule()
    func initializeCreateAccountModule(isFirstResponder: Bool)
    func initializeForgotPasswordModule()
    func didFinishAuthentification()
}
