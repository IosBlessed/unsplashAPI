//
//  CreateAccountViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol CreateAccountViewModelProtocol: AnyObject {
    var emailIsCorrect: Observable <Bool> { get set }
    var passwordIsCorrect: Observable <Bool> { get set }
    var repeatedPassword: Observable <Bool> { get set }
    var shouldEnableButtonCreateAccount: Observable <Bool> { get set }
    func processCreationOfUser(email: String?, password: String?, confirmedPassword: String?)
    func createUser()
}
