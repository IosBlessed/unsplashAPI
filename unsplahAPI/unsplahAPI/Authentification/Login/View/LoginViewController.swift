//
//  LoginViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 26.05.2023.
//

import UIKit

final class LoginViewController: UIViewController, LoginViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage.layer.opacity = 0.0
            let endColor = UIColor.clear
            let startColor = UIColor.white
            let gradientLayer = CAGradientLayer()
            gradientLayer.type = .axial
            gradientLayer.colors = [
                endColor.cgColor,
                startColor.cgColor
            ]
            gradientLayer.locations = [0.5, 0.9]
            backgroundImage.layer.addSublayer(gradientLayer)
        }
    }
    @IBOutlet private weak var loginViewTopConstraint: NSLayoutConstraint! {
        didSet {
            loginViewTopConstraint.constant = Constants.authentificationMarginBackgroundImageTop
        }
    }
    @IBOutlet private weak var loginViewBottomConstraint: UIView!
    @IBOutlet private weak var loginTitleLabel: UILabel! {
        didSet {
            loginTitleLabel.layer.opacity = 0.0
            loginTitleLabel.font = DesignedSystemFonts.headlineBold
            loginTitleLabel.textColor = DesignedSystemColors.primaryText
        }
    }
    @IBOutlet private weak var logInButton: UIButton! {
        didSet {
            logInButton.customiseMainActorButton(
                title: "Log In",
                shadow: true,
                animated: true
            )
        }
    }
    @IBOutlet private weak var forgotPassword: UIButton! {
        didSet {
            forgotPassword.customiseFootnoteButton(
                title: "Forgot your password?",
                fontColor: DesignedSystemColors.primaryText,
                font: DesignedSystemFonts.privacyPolicyText,
                animated: true
            )
        }
    }
    @IBOutlet private weak var createAccount: UIButton! {
        didSet {
            createAccount.customiseFootnoteButton(
                title: "Don't have an accont? Join",
                fontColor: DesignedSystemColors.primaryText,
                font: DesignedSystemFonts.clearButtonFootnoteMainACtor,
                animated: true
            )
        }
    }
    // MARK: - Properties
    var viewModel: LoginViewModelProtocol!
    unowned var coordinator: AuthentificationCoordinatorProtocol!
    private var keyboardCenter: KeyboardNotificationCenter?
    private var delayOnAnimation: Double = 0.0
    private var loginTextFieldsView: LoginTextFields = {
        let loginTextView = LoginTextFields(frame: .zero)
        loginTextView.translatesAutoresizingMaskIntoConstraints = false
        loginTextView.loginTextField.placeholder = "Login"
        loginTextView.passwordTextField.placeholder = "Password"
        loginTextView.repeatPasswordTextField.isHidden = true
        loginTextView.layer.opacity = 0.0
        return loginTextView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.keyboardCenter = KeyboardNotificationCenter(for: self, targetView: self.view)
        self.keyboardCenter?.initializeHideKeyboardGestureRecognizer(selector: #selector(hideKeyboard))
        setupBindings()
        addTargetsToTextFields()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardCenter?.initializeHideKeyboardGestureRecognizer(selector: #selector(hideKeyboard))
        keyboardCenter?.registerKeyboardObserver(
            onAppearance: #selector(keyboardWillShow),
            onHide: #selector(keyboardWillHide)
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let arrayForAnimatedItems = [
            self.backgroundImage,
            self.loginTitleLabel,
            self.loginTextFieldsView,
            self.logInButton,
            self.forgotPassword,
            self.createAccount
        ] as [UIView]
        for element in arrayForAnimatedItems {
            let transition = element == self.backgroundImage ? 1.0  : 0.5
            animateAppearanceElements(
                element: element,
                transition: transition,
                delay: delayOnAnimation
            )
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        keyboardCenter?.removeObserver()
        self.hideKeyboard()
        keyboardCenter = nil
        super.viewWillDisappear(animated)
    }
    // MARK: - Behaviour
    private func setupBindings() {
        viewModel.emailIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let loginField = loginTextFieldsView.loginTextField
            loginTextFieldsView.setupTextFieldBasedOnInput(textField: loginField!, isCorrect: isCorrect)
        }

        viewModel.passswordIsCorrect.bind { [weak self] isCorrect in
            guard let self else { return }
            let passwordField = loginTextFieldsView.passwordTextField
            loginTextFieldsView.setupTextFieldBasedOnInput(textField: passwordField!, isCorrect: isCorrect)
        }
        viewModel.loginButtonIsActive.bind { [weak self] isEnabled in
            guard let self else { return }
            logInButton.shouldButtonBeEnabled(isEnabled: isEnabled)
        }
    }

    private func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "Log In"
        backButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backButtonItem
    }

    private func animateAppearanceElements(element object: UIView, transition onTime: Double, delay fromTime: Double) {
        UIView.animate(withDuration: onTime, delay: fromTime) { [weak self] in
            guard let self else { return }
            object.layer.opacity = object == self.logInButton ? 0.5 : 1.0
            self.delayOnAnimation += onTime
        }
    }

    private func setupConstraints() {
        loginView.addSubview(loginTextFieldsView)
        backgroundImage.layer.sublayers?.first?.frame = view.bounds
        loginTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        createAccount.translatesAutoresizingMaskIntoConstraints = false

        loginTitleLabel.topAnchor.constraint(
            equalTo: loginView.topAnchor
        ).isActive = true
        loginTitleLabel.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 49
        ).isActive = true
        loginTitleLabel.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true
        loginTitleLabel.widthAnchor.constraint(
            equalToConstant: 100
        ).isActive = true

        loginTextFieldsView.topAnchor.constraint(
            equalTo: loginTitleLabel.bottomAnchor,
            constant: 35
        ).isActive = true
        loginTextFieldsView.leadingAnchor.constraint(
            equalTo: loginTitleLabel.leadingAnchor
        ).isActive = true
        loginTextFieldsView.trailingAnchor.constraint(
            equalTo: loginView.trailingAnchor,
            constant: -49
        ).isActive = true
        loginTextFieldsView.heightAnchor.constraint(
            equalToConstant: 100
        ).isActive = true

        logInButton.topAnchor.constraint(
            equalTo: loginTextFieldsView.bottomAnchor,
            constant: 20
        ).isActive = true
        logInButton.leadingAnchor.constraint(
            equalTo: loginView.leadingAnchor,
            constant: 49
        ).isActive = true
        logInButton.trailingAnchor.constraint(
            equalTo: loginView.trailingAnchor,
            constant: -49
        ).isActive = true
        logInButton.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true

        forgotPassword.topAnchor.constraint(
            equalTo: logInButton.bottomAnchor,
            constant: 30
        ).isActive = true
        forgotPassword.leadingAnchor.constraint(
            equalTo: logInButton.leadingAnchor,
            constant: 30
        ).isActive = true
        forgotPassword.trailingAnchor.constraint(
            equalTo: logInButton.trailingAnchor,
            constant: -30
        ).isActive = true
        forgotPassword.heightAnchor.constraint(
            equalToConstant: 14
        ).isActive = true

        createAccount.topAnchor.constraint(
            equalTo: forgotPassword.bottomAnchor,
            constant: 20
        ).isActive = true
        createAccount.leadingAnchor.constraint(
            equalTo: logInButton.leadingAnchor,
            constant: 10
        ).isActive = true
        createAccount.trailingAnchor.constraint(
            equalTo: logInButton.trailingAnchor,
            constant: -10
        ).isActive = true
        createAccount.heightAnchor.constraint(
            equalToConstant: 16
        ).isActive = true
    }

    private func addTargetsToTextFields() {
        for field in loginTextFieldsView.textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
            field.addTarget(self, action: #selector(textFieldChangesText), for: .editingChanged)
        }
    }
    // MARK: - Selectors
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.loginViewTopConstraint.constant = 35
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.loginViewTopConstraint.constant = Constants.authentificationMarginBackgroundImageTop
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func textFieldChangesText() {
        let email = loginTextFieldsView.loginTextField.text
        let password = loginTextFieldsView.passwordTextField.text
        viewModel?.processTextFields(email: email, password: password)
    }

    // MARK: - Actions
    @IBAction func forgotPasswordAction(_ sender: Any) {
        coordinator?.initializeForgotPasswordModule()
    }

    @IBAction func createAccountAction(_ sender: Any) {
        coordinator?.initializeCreateAccountModule(isFirstResponder: true)
    }
}
