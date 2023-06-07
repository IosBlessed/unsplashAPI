//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class LoginViewModel: LoginViewModelProtocol {
    // MARK: - Properties
    var emailIsCorrect: Observable<Bool> = Observable(true)
    var passswordIsCorrect: Observable<Bool> = Observable(true)
    var loginButtonIsActive: Observable<Bool> = Observable(true)
    // MARK: - Behaviour
    func processTextFields(email: String?, password: String?) {
        guard let email, let password else { return }

        if email.count > 6 || email.count == 0 {
            emailIsCorrect.observedObject = true
        } else {
            emailIsCorrect.observedObject = false
        }
        if password.count >= 4 || password.count == 0 {
            passswordIsCorrect.observedObject = true
        } else {
            passswordIsCorrect.observedObject = false
        }
        let containtsEmptyFields = email == "" || password == ""
        loginButtonShouldBeActive(containtsEmptyFields: containtsEmptyFields)
    }
    private func loginButtonShouldBeActive(containtsEmptyFields: Bool) {
        loginButtonIsActive.observedObject = emailIsCorrect.observedObject && passswordIsCorrect.observedObject && !containtsEmptyFields
    }
    
    func loginButtonPressed(username: String, password: String, completion: @escaping (KeychainError?) -> Void) {
        UnsplashAPI.shared.getUserfromKeychain { userDetails in
            
            let storedUsername = userDetails[KeychainUserKeys.username.rawValue]
            let storedPassword = userDetails[KeychainUserKeys.password.rawValue]
            let loginIsCorrect = storedUsername != "" && storedUsername == username
            let passwordIsCorrect = storedPassword != "" && storedPassword == password
            return loginIsCorrect && passwordIsCorrect ? completion(nil) : completion(.unableToExtractPassword)
        }
    }
}
