//
//  Extension+UIButton.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 29.05.2023.
//

import UIKit

extension UIButton {

    func customiseMainActorButton(
        title buttonTitle: String,
        shadow setShadow: Bool,
        cornerRadius: CGFloat = 10.0,
        backgroundColor: UIColor = DesignedSystemColors.primaryContrast,
        animated: Bool = false
    ) {
        let button = self
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = DesignedSystemColors.primaryContrast
        if setShadow {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 1.0
            button.layer.shadowOffset = .zero
            button.layer.shadowRadius = 4.0
        }
        button.setAttributedTitle(
            NSAttributedString(
                string: buttonTitle,
                attributes: [
                    NSAttributedString.Key.font: DesignedSystemFonts.button,
                    NSAttributedString.Key.foregroundColor: DesignedSystemColors.primaryText
                ]),
            for: .normal
        )
        if animated {
            button.layer.opacity = 0.0
        }
    }

    func shouldButtonBeEnabled(isEnabled: Bool) {
        guard self.layer.opacity != 0 else { return }
        if !isEnabled {
            self.layer.opacity = 0.5
            self.isEnabled = isEnabled
        } else {
            self.layer.opacity = 1.0
            self.isEnabled = isEnabled
        }
    }

    func customiseFootnoteButton(
        title titleText: String,
        fontColor foregroundColor: UIColor,
        font: UIFont,
        animated: Bool = false
    ) {
        let button = self
        button.setAttributedTitle(
            NSAttributedString(
                string: titleText,
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: foregroundColor
                ]
            ),
            for: .normal
        )
        if animated {
            button.layer.opacity = 0.0
        }
    }
}
