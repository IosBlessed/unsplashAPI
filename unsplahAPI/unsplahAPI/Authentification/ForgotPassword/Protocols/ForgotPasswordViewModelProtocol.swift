//
//  ForgotPasswordViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol ForgotPasswordViewModelProtocol: AnyObject {
    var emailIsCorrect: Observable<Bool> { get set }
    var showPasswordIsActive: Observable<Bool> { get set }
    func processForgotPasswordTextField(email: String?)
}
