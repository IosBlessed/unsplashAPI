//
//  Extension+UITextField.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 29.05.2023.
//

import UIKit

extension UITextField {
    func customiseTextField(withWrongInput text: String = "") {
        let textField = self
        let bottomBorder = UIView(frame: .zero)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = true
        bottomBorder.frame = CGRect(x: 0, y: textField.bounds.height - 10, width: textField.bounds.width, height: 1)
        bottomBorder.backgroundColor = DesignedSystemColors.textFieldSeparatorColor
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        let wrongDataText = UILabel(frame: .zero)
        wrongDataText.translatesAutoresizingMaskIntoConstraints = true
        wrongDataText.frame = CGRect(
            x: 0,
            y: textField.bounds.height - 5,
            width: textField.bounds.width,
            height: 12
        )
        wrongDataText.attributedText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: Constants.sanFranciscoRegular.withSize(10)
            ]
        )
        wrongDataText.isHidden = true
        textField.insertSubview(bottomBorder, at: 0)
        textField.insertSubview(wrongDataText, at: 1)
    }
}
