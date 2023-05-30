//
//  Extension+UIViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 29.05.2023.
//

import UIKit

extension UIViewController {
    func alertMessage(
        title: String,
        description: String,
        buttonTitle: String,
        handler: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alert.addAction(actionOk)
        return alert
    }
}
