//
//  AuthenticationModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

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
