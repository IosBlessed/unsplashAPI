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
    init() {
        UnsplashAPI.shared.getUserfromKeychain { keychainUserDetails in
            if !keychainUserDetails.isEmpty {
                self.isAuthenticated.observedObject = true
            }
        }
    }
    // MARK: - Behaviour
    func authenticate(username: String, password: String) {
        let user = User()
        user.authenticationState = .authenticated
        self.user = user
    }
}
