//
//  LoginViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 26.05.2023.
//

import UIKit

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
    var viewModel: LoginViewModelProtocol?
    weak var coordinator: AuthentificationCoordinatorProtocol?
    private var delayOnAnimation: Double = 0.0
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
            logInButton.isEnabled = false
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
    
    private var loginTextFieldsView: LoginTextFields = {
        let loginTextView = LoginTextFields(frame: .zero)
        loginTextView.translatesAutoresizingMaskIntoConstraints = false
        loginTextView.loginTextField.placeholder = "Login"
        loginTextView.passwordTextField.placeholder = "Password"
        loginTextView.repeatPasswordTextField.isHidden = true
        loginTextView.layer.opacity = 0.0
        return loginTextView
    }()
    private var keyboardCenter: KeyboardNotificationCenter?
    
    private func loginButtonShouldBeActive(isEmail isCorrectEmail: Bool, isPassword isCorrectPassword: Bool) {
        if isCorrectEmail && isCorrectPassword {
            logInButton.isEnabled = true
            logInButton.layer.opacity = 1.0
        } else {
            logInButton.isEnabled = false
            logInButton.layer.opacity = 0.5
        }
    }
    private func setupTextFieldBasedOnInput(textField field: UITextField, isWrong: Bool) {
        if isWrong {
            field.textColor = .red
            field.subviews[0].backgroundColor = .red
            field.subviews[1].isHidden = false
        } else {
            field.textColor = .black
            field.subviews[0].backgroundColor = DesignedSystemColors.textFieldSeparatorColor
            field.subviews[1].isHidden = true
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardCenter = KeyboardNotificationCenter(for: self, targetView: self.view)
        self.keyboardCenter?.initializeHideKeyboardGestureRecognizer(selector: #selector(hideKeyboard))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        keyboardCenter?.registerKeyboardObserver(
            onAppearance: #selector(keyboardWillShow),
            onHide: #selector(keyboardWillHide)
        )
        for field in loginTextFieldsView.textFieldsStackVIew.arrangedSubviews as? [UITextField] ?? [] {
            field.addTarget(self, action: #selector(processField), for: .allEditingEvents)
        }
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
        super.viewWillDisappear(animated)
        keyboardCenter?.removeObserver()
        self.navigationController?.navigationBar.isHidden = false
        self.hideKeyboard()
        keyboardCenter = nil
    }
    
    private func animateAppearanceElements(element object: UIView, transition onTime: Double, delay fromTime: Double) {
        UIView.animate(withDuration: onTime, delay: fromTime) { [weak self] in
            guard let self else { return }
            object.layer.opacity = object == self.logInButton ? 0.5 : 1.0
            self.delayOnAnimation += onTime
        }
    }
    
    @objc func processField() {
        guard let email = loginTextFieldsView.loginTextField,
              let password = loginTextFieldsView.passwordTextField
        else { return }
        var emailIsCorrect: Bool = false
        var passwordIsCorrect: Bool = false
        viewModel?.processTextFields(email: email.text, password: password.text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .loginIsCorrect:
                self.setupTextFieldBasedOnInput(textField: email, isWrong: false)
                emailIsCorrect = email.text != ""
            case .passwordIsCorrect:
                self.setupTextFieldBasedOnInput(textField: password, isWrong: false)
                passwordIsCorrect = password.text != ""
            case .loginIncorrectFormat:
                self.setupTextFieldBasedOnInput(textField: email, isWrong: true)
                emailIsCorrect = false
            default:
                self.setupTextFieldBasedOnInput(textField: password, isWrong: true)
                passwordIsCorrect = false
            }
            self.loginButtonShouldBeActive(isEmail: emailIsCorrect, isPassword: passwordIsCorrect)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.loginViewTopConstraint.constant = 35
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.loginViewTopConstraint.constant = Constants.authentificationMarginBackgroundImageTop
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "Log In"
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.navigationBar.isHidden = true
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
    @IBAction func forgotPasswordAction(_ sender: Any) {
    }
    @IBAction func createAccountAction(_ sender: Any) {
        coordinator?.initializeCreateAccountModule()
    }
}
