//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol ChangePasswordViewModelProtocol: AnyObject {
    var oldPasswordIsCorrect: Observable<Bool> { get set }
    var newPasswordIsCorrect: Observable<Bool> { get set }
    var newPasswordConfirmationIsCorrect: Observable<Bool> { get set }
    var mainActorButtonShouldBeActive: Observable<Bool> { get set }
    func processTextFields(oldPassword: String, newPassword: String, confirmedPassword: String)
    func changePasswordButtonTapped(
        oldPassword: String,
        newPassword: String,
        completion: @escaping(KeychainError?
        ) -> Void)
}
