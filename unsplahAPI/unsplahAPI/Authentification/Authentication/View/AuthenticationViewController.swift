//
//  AuthenticationViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class AuthenticationViewController: UIViewController, AuthenticationViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var homeScreenView: UIView! {
        didSet {
            homeScreenView.backgroundColor = .white
        }
    }
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var backgroundImageTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var underImageView: UIView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.customiseMainActorButton(
                title: "Create Account",
                shadow: true
            )
        }
    }
    @IBOutlet private weak var logInButton: UIButton! {
        didSet {
            logInButton.customiseMainActorButton(
                title: "Log In",
                shadow: true
            )
        }
    }
    @IBOutlet private weak var underButtonsLabel: UILabel! {
        didSet {
            underButtonsLabel.numberOfLines = 3
            underButtonsLabel.attributedText = NSAttributedString(
                string: "By proceeding you agree to some random terms of service and privacy policy",
                attributes: [
                    NSAttributedString.Key.font: DesignedSystemFonts.privacyPolicyText,
                    NSAttributedString.Key.foregroundColor: DesignedSystemColors.primaryInsignificantText
            ]
            )
        }
    }
    // MARK: - Properties
    var coordinator: AuthentificationCoordinatorProtocol!
    var viewModel: AuthenticationViewModelProtocol!
    private var unitOpacity: Float! {
        didSet {
            for button in buttonsStackView.arrangedSubviews as? [UIButton] ?? [] {
                button.layer.opacity = unitOpacity
            }
            underButtonsLabel.layer.opacity = unitOpacity
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel?.isAuthenticated.bind { [weak self] isAuthenticated in
            guard let self else { return }
            if isAuthenticated {
                self.coordinator?.didFinishAuthentification()
            }
        }
        constructView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unitOpacity = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let transitionOfScrollViewUp: Double = 1.0
        UIView.animate(withDuration: transitionOfScrollViewUp) { [weak self] in
            guard let self else { return }
            self.backgroundImageTopConstraint.constant = -Constants.homeScreenBackgroundImageMovementConstant
            self.backgroundImageBottomConstraint.constant = Constants.homeScreenBackgroundImageMovementConstant
            homeScreenView.layoutIfNeeded()
        }
        UIView.animate(withDuration: 1.0, delay: transitionOfScrollViewUp) { [weak self] in
            guard let self else { return }
            self.unitOpacity = 1.0
        }
    }
    
    // MARK: - Behaviour
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Log In"
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func constructView() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        underButtonsLabel.translatesAutoresizingMaskIntoConstraints = false

        buttonsStackView.topAnchor.constraint(
            equalTo: underImageView.topAnchor,
            constant: 40
        ).isActive = true
        buttonsStackView.trailingAnchor.constraint(
            equalTo: underImageView.trailingAnchor,
            constant: -49
        ).isActive = true
        buttonsStackView.leadingAnchor.constraint(
            equalTo: underImageView.leadingAnchor,
            constant: 49
        ).isActive = true
        buttonsStackView.heightAnchor.constraint(
            equalToConstant: 112
        ).isActive = true

        underButtonsLabel.topAnchor.constraint(
            equalTo: buttonsStackView.bottomAnchor,
            constant: 40
        ).isActive = true
        underButtonsLabel.leadingAnchor.constraint(
            equalTo: underImageView.leadingAnchor,
            constant: 49
        ).isActive = true
        underButtonsLabel.trailingAnchor.constraint(
            equalTo: underImageView.trailingAnchor,
            constant: -49
        ).isActive = true
        underButtonsLabel.heightAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
    }
    
    private func animateViewControllerDissapear() {
        let marginFromTop = homeScreenView.bounds.height / 1.7
        Constants.authentificationMarginBackgroundImageTop = view.bounds.height - marginFromTop
        self.backgroundImageTopConstraint.constant = -view.bounds.height
        self.backgroundImageBottomConstraint.constant = view.bounds.height
        self.unitOpacity = 0.0
        homeScreenView.layoutIfNeeded()
    }
    // MARK: - Actions
    @IBAction func createAccountAction(_ sender: Any) {
        UIView.animate(
            withDuration: 1.0,
            animations: animateViewControllerDissapear
        ) { [weak self] _ in
            guard let self else { return }
            self.coordinator?.initializeCreateAccountModule(isFirstResponder: false)
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        UIView.animate(
            withDuration: 1.0,
            animations: animateViewControllerDissapear
        ) { [weak self] _ in
                guard let self else { return }
                self.coordinator?.initializeLoginModule()
        }
    }
}
