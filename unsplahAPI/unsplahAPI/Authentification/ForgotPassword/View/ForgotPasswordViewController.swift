//
//  ForgotPasswordViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class ForgotPasswordViewController: UIViewController, ForgotPasswordViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var forgotPasswordView: UIView!
    @IBOutlet private weak var forgotPasswordTitle: UILabel!
    @IBOutlet private weak var forgotPasswordSubtitle: UILabel!
    @IBOutlet private weak var confirmButton: UIButton! {
        didSet {
            confirmButton.customiseMainActorButton(
                title: "Confirm",
                shadow: true
            )
        }
    }
    // MARK: - Properties
    var viewModel: ForgotPasswordViewModelProtocol!
    unowned var coordinator: AuthentificationCoordinatorProtocol!
    private var forgotPasswordTextFields: LoginTextFields = {
        let forgotPassword = LoginTextFields(frame: .zero)
        forgotPassword.loginTextField.placeholder = "Enter your email"
        forgotPassword.passwordTextField.isHidden = true
        forgotPassword.repeatPasswordTextField.isHidden = true
        return forgotPassword
    }()
    private var keyboardCenter: KeyboardNotificationCenter?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        initializeKeyboardCenter()
        setupBindings()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forgotPasswordTextFields.loginTextField.addTarget(
            self,
            action: #selector(processInput),
            for: .allEditingEvents
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    // MARK: - Behaviour
    private func setupBindings() {
        viewModel.emailIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let forgotField = forgotPasswordTextFields.loginTextField
            forgotPasswordTextFields.setupTextFieldBasedOnInput(textField: forgotField!, isCorrect: isCorrect)
        }
        viewModel.showPasswordIsActive.bind { [weak self] isEnabled in
            guard let self else { return }
            self.confirmButton.shouldButtonBeEnabled(isEnabled: isEnabled)
        }
    }
    
    private func initializeKeyboardCenter() {
        keyboardCenter = KeyboardNotificationCenter(for: self, targetView: self.view)
        keyboardCenter?.initializeHideKeyboardGestureRecognizer(selector: #selector(hideKeyboard))
    }
    
    private func setupConstraints() {
        forgotPasswordTextFields.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forgotPasswordTextFields)
        
        forgotPasswordTextFields.topAnchor.constraint(
            equalTo: forgotPasswordSubtitle.bottomAnchor,
            constant: 20
        ).isActive = true
        forgotPasswordTextFields.leadingAnchor.constraint(
            equalTo: forgotPasswordSubtitle.leadingAnchor
        ).isActive = true
        forgotPasswordTextFields.trailingAnchor.constraint(
            equalTo: forgotPasswordView.trailingAnchor,
            constant: -43
        ).isActive = true
        forgotPasswordTextFields.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
        
        confirmButton.topAnchor.constraint(
            equalTo: forgotPasswordTextFields.bottomAnchor,
            constant: 20
        ).isActive = true
        confirmButton.leadingAnchor.constraint(
            equalTo: forgotPasswordTextFields.leadingAnchor
        ).isActive = true
        confirmButton.trailingAnchor.constraint(
            equalTo: forgotPasswordTextFields.trailingAnchor
        ).isActive = true
        confirmButton.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true
    }
    // MARK: - Selectors
    @objc func processInput() {
        let email = forgotPasswordTextFields.loginTextField.text
        viewModel.processForgotPasswordTextField(email: email)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    //MARK: - Actions
    @IBAction func passwordConfirmationButtonTapped(_ sender: Any) {
        // TODO: if user's mail addres is stored in keychain, show alert
        let alert = self.alertMessage(
            title: "Request password",
            description: "Here will be shown your password",
            buttonTitle: "Thanks!"
        ) { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        present(alert, animated: true)
    }
}
