//
//  CreateAccountViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class CreateAccountViewModel: CreateAccountViewModelProtocol {
    
    func processCreationOfUser(
        email: String?,
        password: String?,
        confirmedPassword: String?,
        completion: (TextFieldProcess) -> Void
    ) {
        guard let email,
              let password,
              let confirmedPassword
        else { return }
        if (email.count >= 6 && email.contains("@")) || email.count == 0 {
            completion(.loginIsCorrect)
        } else {
            completion(.loginIncorrectFormat)
        }
        if password.count >= 4 || password.count == 0 {
            completion(.passwordIsCorrect)
        } else {
            completion(.passwordIsShort)
        }
        if confirmedPassword == password {
            completion(.passwordsAreTheSame)
        } else {
            completion(.passwordsAreNotTheSame)
        }
    }
    
    func createUser() {
    }
}
