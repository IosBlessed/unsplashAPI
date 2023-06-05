//
//  CreateAccountViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class CreateAccountViewController: UIViewController, CreateAccountViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var createAccountView: UIView!
    @IBOutlet private weak var createAccountLabel: UILabel! {
        didSet {
            createAccountLabel.textColor = DesignedSystemColors.primaryText
        }
    }
    @IBOutlet private weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.customiseMainActorButton(
                title: "Create Account",
                shadow: true
            )
        }
    }
    @IBOutlet private weak var createAccountTopConstraint: NSLayoutConstraint!
    // MARK: - Properties
    var viewModel: CreateAccountViewModelProtocol!
    unowned var coordinator: AuthentificationCoordinatorProtocol!
    private var keyboardCenter: KeyboardNotificationCenter?
    private var constantOfLoginLabelTopConstraint: CGFloat!
    private var createAccountTextFieldsView: LoginTextFields = {
        let createAccountView = LoginTextFields(frame: .zero)
        createAccountView.loginTextField.placeholder = "Enter your email"
        createAccountView.passwordTextField.placeholder = "Enter your password"
        createAccountView.repeatPasswordTextField.placeholder = "Confirm your password"
        return createAccountView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        initializeTargetsForTextFields()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardCenter?.registerKeyboardObserver(
            onAppearance: #selector(keyboardWillShow),
            onHide: #selector(keyboardWillHide)
        )
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardCenter?.removeObserver()
        self.hideKeyboard()
        keyboardCenter = nil
    }
    // MARK: - Behaviour
    private func initialSetup() {
        setupKeyboardCenter()
        self.constantOfLoginLabelTopConstraint = createAccountTopConstraint.constant
        self.createAccountView.backgroundColor = DesignedSystemColors.primary
    }

    private func setupBindings() {
        guard let emailField = createAccountTextFieldsView.loginTextField,
              let passwordField = createAccountTextFieldsView.passwordTextField,
              let confirmedPassword = createAccountTextFieldsView.repeatPasswordTextField
        else { return }
        viewModel?.emailIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            self.createAccountTextFieldsView.setupTextFieldBasedOnInput(
                textField: emailField,
                isCorrect: isCorrect
            )
        }
        viewModel?.passwordIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            self.createAccountTextFieldsView.setupTextFieldBasedOnInput(
                textField: passwordField,
                isCorrect: isCorrect
            )
        }
        viewModel?.repeatedPassword.bind { [weak self] passwordsMatch in
            guard let self else { return }
            self.createAccountTextFieldsView.setupTextFieldBasedOnInput(
                textField: confirmedPassword,
                isCorrect: passwordsMatch
            )
        }
        viewModel.shouldEnableButtonCreateAccount.bind { [weak self] isEnabled in
            guard let self else { return }
            self.createAccountButton.shouldButtonBeEnabled(isEnabled: isEnabled)
        }
    }

    private func setupKeyboardCenter() {
        self.keyboardCenter = KeyboardNotificationCenter(
            for: self,
            targetView: createAccountView
        )
        self.keyboardCenter?.initializeHideKeyboardGestureRecognizer(
            selector: #selector(hideKeyboard)
        )
    }

    private func setupConstraints() {
        createAccountTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false

        createAccountView.addSubview(createAccountTextFieldsView)
        createAccountView.addSubview(createAccountButton)

        createAccountTextFieldsView.topAnchor.constraint(
            equalTo: createAccountLabel.bottomAnchor,
            constant: 20
        ).isActive = true
        createAccountTextFieldsView.leadingAnchor.constraint(
            equalTo: createAccountLabel.leadingAnchor
        ).isActive = true
        createAccountTextFieldsView.trailingAnchor.constraint(
            equalTo: createAccountView.trailingAnchor,
            constant: -49
        ).isActive = true
        createAccountTextFieldsView.heightAnchor.constraint(
            equalToConstant: 180
        ).isActive = true

        createAccountButton.topAnchor.constraint(
            equalTo: createAccountTextFieldsView.bottomAnchor,
            constant: 20
        ).isActive = true
        createAccountButton.leadingAnchor.constraint(
            equalTo: createAccountTextFieldsView.leadingAnchor
        ).isActive = true
        createAccountButton.trailingAnchor.constraint(
            equalTo: createAccountTextFieldsView.trailingAnchor
        ).isActive = true
        createAccountButton.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true
    }

    private func initializeTargetsForTextFields() {
        for field in createAccountTextFieldsView.textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
            field.addTarget(self, action: #selector(processInput), for: .allEditingEvents)
        }
    }
    // MARK: - Selectors
    @objc private func processInput() {
        let email = createAccountTextFieldsView.loginTextField.text
        let password = createAccountTextFieldsView.passwordTextField.text
        let confirmedPassword = createAccountTextFieldsView.repeatPasswordTextField.text
        viewModel.processCreationOfUser(email: email, password: password, confirmedPassword: confirmedPassword)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let self else { return }
            self.createAccountTopConstraint.constant = 35
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let self else { return }
            self.createAccountTopConstraint.constant = self.constantOfLoginLabelTopConstraint
            self.view.layoutIfNeeded()
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
