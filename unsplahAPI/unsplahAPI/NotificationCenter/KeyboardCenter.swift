//
//  KeyboardCenter.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 29.05.2023.
//

import UIKit

class KeyboardNotificationCenter: Any {

    private unowned var viewController: UIViewController
    private unowned var targetView: UIView
    private var hideKeyboardGesture: UITapGestureRecognizer?

    init(
        for viewController: UIViewController,
        targetView: UIView
    ) {
        self.viewController = viewController
        self.targetView = targetView
    }

    func registerKeyboardObserver(
        onAppearance: Selector,
        onHide: Selector,
        object: AnyObject? = nil
    ) {
        NotificationCenter.default.addObserver(
            viewController,
            selector: onAppearance,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            viewController,
            selector: onHide,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func initializeHideKeyboardGestureRecognizer(selector: Selector) {
        hideKeyboardGesture = UITapGestureRecognizer(
            target: viewController,
            action: selector
        )
        targetView.addGestureRecognizer(hideKeyboardGesture!)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        guard let hideKeyboardGesture else { return }
        targetView.removeGestureRecognizer(hideKeyboardGesture)
    }
}
