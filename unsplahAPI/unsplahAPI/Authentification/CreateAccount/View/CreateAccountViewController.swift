//
//  CreateAccountViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit


class CreateAccountViewController: UIViewController, CreateAccountViewControllerProtocol {
    var viewModel: CreateAccountViewModelProtocol?
    weak var coordinator: AuthentificationCoordinatorProtocol?
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
                shadow: true,
                shouldBeActive: false
            )
        }
    }
    @IBOutlet private weak var createAccountTopConstraint: NSLayoutConstraint!
    private var constantOfLabelTopConstraint: CGFloat!
    private var createAccountTextFieldsView: LoginTextFields = {
        let createAccountView = LoginTextFields(frame: .zero)
        createAccountView.loginTextField.placeholder = "Enter your email"
        createAccountView.passwordTextField.placeholder = "Enter your password"
        createAccountView.repeatPasswordTextField.placeholder = "Confirm your password"
        return createAccountView
    }()
    private var keyboardCenter: KeyboardNotificationCenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        initializeTargetsForTextFields()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
    private func initialSetup() {
        setupKeyboardCenter()
        self.constantOfLabelTopConstraint = createAccountTopConstraint.constant
        self.createAccountView.backgroundColor = DesignedSystemColors.primary
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
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
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
    
    private func createAccountButtonShouldBeActive(
        isEmail isCorrectEmail: Bool,
        isPassword isCorrectPassword: Bool,
        isEqualPasswords: Bool
    ) {
        if isCorrectEmail && isCorrectPassword && isEqualPasswords {
            createAccountButton.isEnabled = true
            createAccountButton.layer.opacity = 1.0
        } else {
            createAccountButton.isEnabled = false
            createAccountButton.layer.opacity = 0.5
        }
    }
    
    @objc func processInput() {
        guard  let email = createAccountTextFieldsView.loginTextField,
               let password = createAccountTextFieldsView.passwordTextField,
               let confirmedPassword = createAccountTextFieldsView.repeatPasswordTextField
        else { return }
        var emailIsCorrect: Bool = false
        var passwordIsCorrect: Bool = false
        var equalPasswords: Bool = false
        viewModel?.processCreationOfUser(
            email: email.text,
            password: password.text,
            confirmedPassword: confirmedPassword.text
        ) { [weak self] inputStatus in
            guard let self else { return }
            switch inputStatus {
            case .loginIsCorrect:
                self.setupTextFieldBasedOnInput(textField: email, isWrong: false)
                emailIsCorrect = email.text != ""
            case .passwordIsCorrect:
                self.setupTextFieldBasedOnInput(textField: password, isWrong: false)
                passwordIsCorrect = password.text != ""
            case .passwordsAreTheSame:
                self.setupTextFieldBasedOnInput(textField: confirmedPassword, isWrong: false)
                equalPasswords = confirmedPassword.text != ""
            case .loginIncorrectFormat:
                self.setupTextFieldBasedOnInput(textField: email, isWrong: true)
                emailIsCorrect = false
            case .passwordIsShort:
                self.setupTextFieldBasedOnInput(textField: password, isWrong: true)
                passwordIsCorrect = false
            case .passwordsAreNotTheSame:
                self.setupTextFieldBasedOnInput(textField: confirmedPassword, isWrong: true)
                equalPasswords = false
            }
            self.createAccountButtonShouldBeActive(isEmail: emailIsCorrect, isPassword: passwordIsCorrect, isEqualPasswords: equalPasswords)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let self else { return }
            self.createAccountTopConstraint.constant = 35
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let self else { return }
            self.createAccountTopConstraint.constant = self.constantOfLabelTopConstraint
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
