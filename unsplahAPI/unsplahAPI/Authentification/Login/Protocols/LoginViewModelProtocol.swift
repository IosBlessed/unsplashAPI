//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol LoginViewModelProtocol: AnyObject {
    func processTextFields(
        email: String?,
        password: String?,
        completion: (TextFieldProcess) -> Void
    )
    
}
