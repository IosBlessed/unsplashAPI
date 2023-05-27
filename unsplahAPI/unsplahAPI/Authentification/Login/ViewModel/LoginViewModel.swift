//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

enum TextFieldProcess: String, Error {
    case loginIncorrectFormat = "Incorrect format of login"
    case passwordIsShort = "Password is too short"
    case passwordsAreNotTheSame = "Repeated password doesn't match"
    case loginIsCorrect
    case passwordIsCorrect
    case passwordsAreTheSame
}

class LoginViewModel: LoginViewModelProtocol {
    func processTextFields(
        email: String?,
        password: String?,
        completion: (TextFieldProcess) -> Void
    ) {
        guard let email, let password else { return }
        
        if email.count < 6 && email.count > 0 {
            completion(.loginIncorrectFormat)
        } else {
            completion(.loginIsCorrect)
        }
        
        if password.count < 4 && password.count > 0 {
            completion(.passwordIsShort)
        } else {
            completion(.passwordIsCorrect)
        }
        
    }
}
