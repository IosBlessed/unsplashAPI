//
//  CreateAccountViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol CreateAccountViewModelProtocol: AnyObject {
    func processCreationOfUser(
        email: String?,
        password: String?,
        confirmedPassword: String?,
        completion: (TextFieldProcess) -> Void
    )
    func createUser()
}
