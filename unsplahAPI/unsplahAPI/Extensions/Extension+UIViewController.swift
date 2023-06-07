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
        buttonDefaultTitle: String,
        buttonDestructiveTitle: String? = nil,
        handlerDestructive: @escaping (UIAlertAction) -> Void,
        handlerDefault: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: buttonDefaultTitle, style: .cancel, handler: handlerDefault)
        alert.addAction(actionDefault)
        if buttonDestructiveTitle != nil {
            let actionDestructive = UIAlertAction(title: buttonDestructiveTitle, style: .destructive, handler: handlerDestructive)
            alert.addAction(actionDestructive)
        }
        return alert
    }
}
