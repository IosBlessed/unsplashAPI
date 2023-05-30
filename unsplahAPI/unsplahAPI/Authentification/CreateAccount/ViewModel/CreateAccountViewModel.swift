//
//  CreateAccountViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class CreateAccountViewModel: CreateAccountViewModelProtocol {
    // MARK: - Properties
    var emailIsCorrect: Observable<Bool> = Observable(true)
    var passwordIsCorrect: Observable<Bool> = Observable(true)
    var repeatedPassword: Observable<Bool> = Observable(true)
    var shouldEnableButtonCreateAccount: Observable<Bool> = Observable(false)
    // MARK: - Behaviour
    func processCreationOfUser(email: String?, password: String?, confirmedPassword: String?) {
        guard let email,
              let password,
              let confirmedPassword
        else { return }
        if (email.count >= 6 && email.contains("@")) || email.count == 0 {
            emailIsCorrect.observedObject = true
        } else {
            emailIsCorrect.observedObject = false
        }
        if password.count >= 4 || password.count == 0 {
            passwordIsCorrect.observedObject = true
        } else {
            passwordIsCorrect.observedObject = false
        }
        if confirmedPassword == password {
            repeatedPassword.observedObject = true
        } else {
            repeatedPassword.observedObject = false
        }
        let fieldsAreEmpty = email == "" || password == "" || confirmedPassword == ""
        shouldHideCreateAccountButton(fieldsAreEmpty: fieldsAreEmpty)
    }

    private func shouldHideCreateAccountButton(fieldsAreEmpty: Bool) {
        let passwordsAreSame = passwordIsCorrect.observedObject && repeatedPassword.observedObject
        let shouldHideButton = passwordsAreSame && emailIsCorrect.observedObject && !fieldsAreEmpty
        shouldEnableButtonCreateAccount.observedObject = shouldHideButton
    }
    
    func createUser() {
    }
}
