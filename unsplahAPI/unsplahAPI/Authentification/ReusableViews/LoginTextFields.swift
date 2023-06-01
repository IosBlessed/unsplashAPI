//
//  loginTextFields.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 26.05.2023.
//

import UIKit

final class LoginTextFields: UIView {
    // MARK: - Enums
    enum TextFieldProcess: String, Error {
        case loginIncorrectFormat = "The email entered isn't valid"
        case passwordIsShort = "Password is too short"
        case passwordsAreNotTheSame = "Passwords do not match"
    }
    // MARK: - Outlets
    @IBOutlet weak var textFieldsStackVIew: UIStackView! {
        didSet {
            for field in textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
                field.autocorrectionType = .no
                field.keyboardType = .default
            }
        }
    }
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.customiseTextField(withWrongInput: TextFieldProcess.loginIncorrectFormat.rawValue)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.customiseTextField(withWrongInput: TextFieldProcess.passwordIsShort.rawValue)
            passwordTextField.textContentType = .password
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var repeatPasswordTextField: UITextField! {
        didSet {
            repeatPasswordTextField.customiseTextField(withWrongInput: TextFieldProcess.passwordsAreNotTheSame.rawValue)
            repeatPasswordTextField.textContentType = .password
            repeatPasswordTextField.isSecureTextEntry = true
        }
    }
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let viewFromNib = loadFromNib() else { return }
        self.addSubview(viewFromNib)
        self.addSubview(textFieldsStackVIew)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Behaviour
    private func loadFromNib() -> UIView? {
        let nibName = String(describing: LoginTextFields.self)
        let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        return nibView
    }

    func setupTextFieldBasedOnInput(textField field: UITextField, isCorrect: Bool) {
        if !isCorrect {
            field.textColor = .red
            field.subviews[0].backgroundColor = .red
            field.subviews[1].isHidden = false

        } else {
            field.textColor = .black
            field.subviews[0].backgroundColor = DesignedSystemColors.textFieldSeparatorColor
            field.subviews[1].isHidden = true
        }
    }
}
