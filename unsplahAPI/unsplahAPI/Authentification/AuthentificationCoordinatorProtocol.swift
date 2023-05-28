//
//  AuthentificationCoordinatorProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol AuthentificationCoordinatorProtocol: AnyObject {
    func initializeAuthorizationProcess()
    func initializeLoginModule()
    func initializeCreateAccountModule()
    func didFinishAuthentification()
}
