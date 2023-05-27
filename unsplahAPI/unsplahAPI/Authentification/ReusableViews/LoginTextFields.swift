//
//  loginTextFields.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 26.05.2023.
//

import UIKit

extension UITextField {
    func customiseTextField(withWrongInput text: String = "") {
        let textField = self
        let bottomBorder = UIView(frame: .zero)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = true
        bottomBorder.frame = CGRect(x: 0, y: textField.bounds.height - 10, width: textField.bounds.width, height: 1)
        bottomBorder.backgroundColor = DesignedSystemColors.textFieldSeparatorColor
        textField.addSubview(bottomBorder)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        let wrongData = UILabel(frame: .zero)
        wrongData.translatesAutoresizingMaskIntoConstraints = true
        wrongData.frame = CGRect(
            x: 0,
            y: textField.bounds.height - 5,
            width: textField.bounds.width,
            height: 12
        )
        wrongData.attributedText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: Constants.sanFranciscoRegular.withSize(10)
            ]
        )
        wrongData.isHidden = true
        textField.addSubview(wrongData)
    }
}

class LoginTextFields: UIView {

    @IBOutlet weak var textFieldsStackVIew: UIStackView! {
        didSet {
            for field in textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
                field.isUserInteractionEnabled = true
                field.autocorrectionType = .no
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
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let viewFromNib = loadFromNib() else { return }
        self.addSubview(viewFromNib)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadFromNib() -> UIView? {
        let nibName = String(describing: LoginTextFields.self)
        let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        return nibView
    }
}
