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
            button.layer.shadowRadius = 2.0
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

    func shouldButtonBeEnabled(isActive: Bool) {
        self.isEnabled = isActive
        self.layer.opacity = isActive ? 1.0 : 0.5
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
    
    func animateButtonWhenTapping() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
