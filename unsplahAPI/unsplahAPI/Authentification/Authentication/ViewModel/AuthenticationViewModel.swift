//
//  AuthenticationViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
import Combine
import UIKit

enum AuthenticationState: String, CaseIterable {
    case authenticating
    case unauthenticated
    case authenticated
}

enum AuthenticationFlow: String {
    case login
    case signUp
}

enum AuthenticationErrors: String, Error {
    case unableToIdentifyUser = "User is not authenticated!"
    func localizedDescription() -> String {
        return self.rawValue
    }
}

class User: ObservableObject {
    @Published var username: String? = ""
    @Published var password: String? = ""
    @Published var email: String? = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var authenticationFlow: AuthenticationFlow = .login

    func logOut() {
        username = nil
        password = nil
        email = nil
        authenticationState = .unauthenticated
    }
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    var user: User = User()

    func authenticate(username: String, password: String) {
        // TODO: request for user's authentication
        // if user not exists, authentication state => unauthenticate
    }
}