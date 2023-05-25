//
//  AuthenticationViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit
import Combine

class AuthenticationViewController: UIViewController, AuthenticationViewControllerProtocol {

    var coordinator: AuthentificationCoordinatorProtocol?
    var viewModel: AuthenticationViewModelProtocol?
    private var userCancelable: AnyCancellable?
    private var unitOpacity: Float! {
        didSet {
            for button in buttonsStackView.arrangedSubviews as? [UIButton] ?? [] {
                button.layer.opacity = unitOpacity
            }
            underButtonsLabel.layer.opacity = unitOpacity
        }
    }
    @IBOutlet private weak var homeScreenView: UIView! {
        didSet {
            homeScreenView.backgroundColor = .white
        }
    }
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var backgroundImageTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var underImageView: UIView!
    @IBOutlet private weak var buttonsStackView: UIStackView! {
        didSet {
            for button in buttonsStackView.arrangedSubviews as? [UIButton] ?? [] {
                button.layer.masksToBounds = true
                button.layer.cornerRadius = button.bounds.height / 4
            }
        }
    }
    @IBOutlet private weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.setAttributedTitle(
                NSAttributedString(
                    string: "Create Account",
                    attributes: [
                        NSAttributedString.Key.font: DesignedSystemFonts.bodyBold,
                        NSAttributedString.Key.foregroundColor: DesignedSystemColors.primaryText
                    ]),
                for: .normal
            )
        }
    }
    @IBOutlet private weak var logInButton: UIButton! {
        didSet {
            logInButton.setAttributedTitle(
                NSAttributedString(
                    string: "Log In",
                    attributes: [
                        NSAttributedString.Key.font: DesignedSystemFonts.bodyBold,
                        NSAttributedString.Key.foregroundColor: DesignedSystemColors.primaryText
                    ]),
                for: .normal
            )
        }
    }
    @IBOutlet private weak var underButtonsLabel: UILabel! {
        didSet {
            underButtonsLabel.numberOfLines = 3
            underButtonsLabel.attributedText = NSAttributedString(
                string: "By proceeding you agree to some random terms of service and privacy policy",
                attributes: [
                    NSAttributedString.Key.font: DesignedSystemFonts.smallText,
                    NSAttributedString.Key.foregroundColor: DesignedSystemColors.primaryInsignificantText
            ]
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userCancelable = viewModel?.user.$authenticationState.sink { [weak self] autheticationState in
            switch autheticationState {
            case .unauthenticated:
                // TODO: show auth screen
                self?.authenticationProcess(result: .failure(AuthenticationErrors.unableToIdentifyUser))
            case .authenticated:
                self?.authenticationProcess(result: .success(self?.viewModel?.user))
            case .authenticating:
                // TODO: perform default process
                print(autheticationState)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unitOpacity = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let transitionOfScrollViewUp: Double = 2.0
        UIView.animate(withDuration: transitionOfScrollViewUp) { [weak self] in
            guard let self else { return }
            self.backgroundImageTopConstraint.constant = -280
            self.backgroundImageBottomConstraint.constant = 280
            homeScreenView.layoutIfNeeded()
        }
        UIView.animate(withDuration: 1.0, delay: transitionOfScrollViewUp) { [weak self] in
            guard let self else { return }
            self.unitOpacity = 1.0
        }
    }

    func authenticationProcess(result: Result <User?, AuthenticationErrors>) {
        switch result {
        case .success(let _):
            coordinator?.didFinishAuthentification()
        case .failure(let error):
            self.constructView()
            print(error.rawValue)
        }
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userCancelable = nil
    }
}
