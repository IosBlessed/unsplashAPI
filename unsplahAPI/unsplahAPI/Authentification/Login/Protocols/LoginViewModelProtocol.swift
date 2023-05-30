//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol LoginViewModelProtocol: AnyObject {
    var emailIsCorrect: Observable<Bool> { get }
    var passswordIsCorrect: Observable<Bool> { get }
    var loginButtonIsActive: Observable<Bool> { get }
    func processTextFields(email: String?, password: String?)
}
