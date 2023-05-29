//
//  AuthenticationViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
import UIKit

protocol AuthenticationViewModelProtocol: AnyObject {
    var isAuthenticated: Observable<Bool> { get }
    func authenticate(username: String, password: String)
}
