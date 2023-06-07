//
//  ForgotPasswordViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {

    var emailIsCorrect: Observable<Bool> = Observable(true)
    var showPasswordIsActive: Observable<Bool> = Observable(false)

    func processForgotPasswordTextField( email: String?) {
        guard let email else { return }
        if (email.count >= 6 && email.contains("@")) || email.count == 0 {
            emailIsCorrect.observedObject = true
        } else {
            emailIsCorrect.observedObject = false
        }
        let isFieldEmpty = email == ""
        showPasswordButtonShouldBeActive(containtsEmptyFields: isFieldEmpty)
    }
    
    private func showPasswordButtonShouldBeActive(containtsEmptyFields: Bool) {
        showPasswordIsActive.observedObject = !containtsEmptyFields && emailIsCorrect.observedObject
    }
    
    func forgotPasswordButtonTouched(username: String, completion: @escaping (String) -> Void) {
        // request password from core data
        UnsplashAPI.shared.getUserfromKeychain { userDetails in
            var completionString: String = ""
            UnsplashAPI.shared.getUserfromKeychain { userDetails in
                if userDetails[KeychainUserKeys.username.rawValue] == username {
                    completionString = userDetails[KeychainUserKeys.password.rawValue]!
                } else {
                    completionString = "User doesn't exists"
                }
                return completion(completionString)
            }
        }
    }
}
