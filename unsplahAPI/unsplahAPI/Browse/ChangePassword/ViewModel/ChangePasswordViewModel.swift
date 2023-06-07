//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    
    var oldPasswordIsCorrect: Observable<Bool> = Observable(true)
    var newPasswordIsCorrect: Observable<Bool> = Observable(true)
    var newPasswordConfirmationIsCorrect: Observable<Bool> = Observable(true)
    var mainActorButtonShouldBeActive: Observable<Bool> = Observable(false)
    
    func processTextFields(oldPassword: String, newPassword: String, confirmedPassword: String) {
        let oldPasswordStatus = oldPassword.count >= 4 || oldPassword.count == 0
        let newPasswordStatus = newPassword.count >= 4 || newPassword.count == 0 
        let confirmPasswordStatus = newPassword == confirmedPassword
        
        oldPasswordIsCorrect.observedObject = oldPasswordStatus
        newPasswordIsCorrect.observedObject = newPasswordStatus
        newPasswordConfirmationIsCorrect.observedObject = confirmPasswordStatus
        
        let fieldsAreNotEmpty = oldPassword != "" && newPassword != "" && confirmedPassword != ""
        let enteredInformationIsCorrect = oldPasswordStatus && newPasswordStatus && confirmPasswordStatus
        shouldActivateChangePasswordButton(fieldsNotEmpty: fieldsAreNotEmpty, isActive: enteredInformationIsCorrect)
    }
    private func shouldActivateChangePasswordButton(fieldsNotEmpty: Bool, isActive: Bool) {
        mainActorButtonShouldBeActive.observedObject = fieldsNotEmpty && isActive
    }
    func changePasswordButtonTapped(oldPassword: String, newPassword: String, completion: @escaping(KeychainError?) -> Void) {
        UnsplashAPI.shared.getUserfromKeychain { userDetails in
            let storedPassword = userDetails[KeychainUserKeys.password.rawValue] ?? ""
            guard oldPassword == storedPassword else { return completion(.passwordMissMatch) }
            UnsplashAPI.shared.updateUserPassword(oldPassword: oldPassword, newPassword: newPassword) { queryStatus in
                return queryStatus == nil ? completion(nil) : completion(.passwordMissMatch)
            }
        }
    }
}
