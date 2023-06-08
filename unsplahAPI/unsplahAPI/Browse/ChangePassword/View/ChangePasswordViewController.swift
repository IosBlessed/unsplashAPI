//
//  ChangePasswordViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class ChangePasswordViewController: UIViewController, ChangePasswordViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var changePasswordLabel: UILabel!
    @IBOutlet private weak var changePasswordButton: UIButton! {
        didSet {
            changePasswordButton.shouldButtonBeEnabled(isActive: false)
            changePasswordButton.customiseMainActorButton(title: "Change Password", shadow: true)
        }
    }
    @IBOutlet private weak var changePasswordLabelTopConstraint: NSLayoutConstraint!
    // MARK: - Properties
    private let changePasswordTextFields: LoginTextFields! = {
        let textFields = LoginTextFields(frame: .zero)
        textFields.loginTextField.placeholder = "Old password"
        textFields.loginTextField.textContentType = .password
        textFields.loginTextField.isSecureTextEntry = true
        textFields.loginTextField.customiseTextField(withWrongInput: "Password is too short")
        textFields.passwordTextField.placeholder = "New password..."
        textFields.repeatPasswordTextField.placeholder = "Repeat new password"
        return textFields
    }()
    private var keyboardNotificationCenter: KeyboardNotificationCenter!
    var viewModel: ChangePasswordViewModelProtocol!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignedSystemColors.primary
        setupNavigationBar()
        addTargetToTextFields()
        setupConstraints()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupKeyboardNotificationCenter()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardNotificationCenter.removeObserver()
    }
    // MARK: - Behaviour
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func addTargetToTextFields() {
        for textField in changePasswordTextFields.textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
            textField.addTarget(self, action: #selector(processTextFields), for: .allEditingEvents)
        }
    }
    
    private func setupConstraints() {
        changePasswordTextFields.translatesAutoresizingMaskIntoConstraints = false
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(changePasswordTextFields)
        view.addSubview(changePasswordButton)
        
        changePasswordTextFields.topAnchor.constraint(
            equalTo: changePasswordLabel.bottomAnchor,
            constant: 40)
        .isActive = true
        changePasswordTextFields.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 49
        ).isActive = true
        changePasswordTextFields.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -49
        ).isActive = true
        changePasswordTextFields.heightAnchor.constraint(
            equalToConstant: 180
        ).isActive = true
        
        changePasswordButton.topAnchor.constraint(
            equalTo: changePasswordTextFields.bottomAnchor
        ).isActive = true
        changePasswordButton.leadingAnchor.constraint(
            equalTo: changePasswordTextFields.leadingAnchor
        ).isActive = true
        changePasswordButton.trailingAnchor.constraint(
            equalTo: changePasswordTextFields.trailingAnchor
        ).isActive = true
        changePasswordButton.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
    }
    
    private func setupBindings() {
        viewModel.oldPasswordIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let oldPasswordTextField = self.changePasswordTextFields.loginTextField
            changePasswordTextFields.setupTextFieldBasedOnInput(textField: oldPasswordTextField!, isCorrect: isCorrect)
        }
        viewModel.newPasswordIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let newPasswordTextField = self.changePasswordTextFields.passwordTextField
            changePasswordTextFields.setupTextFieldBasedOnInput(textField: newPasswordTextField!, isCorrect: isCorrect)
        }
        viewModel.newPasswordConfirmationIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let repeatNewPassword = self.changePasswordTextFields.repeatPasswordTextField
            changePasswordTextFields.setupTextFieldBasedOnInput(textField: repeatNewPassword!, isCorrect: isCorrect)
        }
        viewModel.mainActorButtonShouldBeActive.bind { [weak self] isActive in
            guard let self else { return }
            self.changePasswordButton.shouldButtonBeEnabled(isActive: isActive)
        }
    }
    
    private func setupKeyboardNotificationCenter() {
        keyboardNotificationCenter = KeyboardNotificationCenter(for: self, targetView: self.view)
        keyboardNotificationCenter.initializeHideKeyboardGestureRecognizer(
            selector: #selector(tapToHideKeyboard)
        )
        keyboardNotificationCenter.registerKeyboardObserver(
            onAppearance: #selector(keyboardWillAppear),
            onHide: #selector(keyboardWillHide)
        )
    }
    // MARK: - Selectors
    @objc func processTextFields() {
        let oldPassword = changePasswordTextFields.loginTextField.text ?? ""
        let newPassword = changePasswordTextFields.passwordTextField.text ?? ""
        let repeatedPassword = changePasswordTextFields.repeatPasswordTextField.text ?? ""
        viewModel.processTextFields(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmedPassword: repeatedPassword
        )
    }
    
    @objc func tapToHideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.changePasswordLabelTopConstraint.constant = -50
            self.view.layoutSubviews()
        }
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.changePasswordLabelTopConstraint.constant = 100
            self.view.layoutSubviews()
        }
    }
    // MARK: - Actions
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        if changePasswordButton.isEnabled {
            changePasswordButton.animateButtonWhenTapping()
            let oldPassword = changePasswordTextFields.loginTextField.text!
            let newPassword = changePasswordTextFields.passwordTextField.text!
            viewModel.changePasswordButtonTapped(
                oldPassword: oldPassword,
                newPassword: newPassword
            ) { [weak self] executionFailureCode in
                guard let self else { return }
                let alertCompletionHandler: (UIAlertAction) -> Void
                let alertMessage: String
                if executionFailureCode == nil {
                    alertMessage = "Your password been successfully changed!"
                    alertCompletionHandler = { _ in  self.navigationController?.popToRootViewController(animated: true)}
                } else {
                    alertMessage = "Your old password is not correct, please, try once again!"
                    alertCompletionHandler = { _ in }
                }
                let alert = self.alertMessage(
                    title: "Password request",
                    description: alertMessage,
                    buttonDefaultTitle: "Thanks!",
                    handlerDestructive: { _ in },
                    handlerDefault: alertCompletionHandler
                )
                self.present(alert, animated: true)
            }
        }
    }
}
