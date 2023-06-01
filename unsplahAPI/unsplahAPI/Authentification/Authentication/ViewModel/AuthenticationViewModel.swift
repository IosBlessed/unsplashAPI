//
//  AuthenticationViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
import Combine
import UIKit

final class AuthenticationViewModel: AuthenticationViewModelProtocol {
    // MARK: - Properties
    var isAuthenticated: Observable<Bool> = Observable(false)
    var user: User? {
        didSet {
            switch user!.authenticationState {
            case .authenticated:
                self.isAuthenticated.observedObject = true
            default:
                print(user!.authenticationState)
            }
        }
    }
    // MARK: - Behaviour
    func authenticate(username: String, password: String) {
        // TODO: request for user's authentication
        // extraction user from KeychainService and assign to model of User()
        let user = User()
        user.authenticationState = .authenticated
        self.user = user
    }
}
