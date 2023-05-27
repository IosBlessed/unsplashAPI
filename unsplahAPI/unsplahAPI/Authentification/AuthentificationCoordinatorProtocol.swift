//
//  AuthentificationCoordinatorProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol AuthentificationCoordinatorProtocol: AnyObject {
    func initializeAuthorizationProcess()
    func initializeLoginProcess()
    func didFinishAuthentification()
}
