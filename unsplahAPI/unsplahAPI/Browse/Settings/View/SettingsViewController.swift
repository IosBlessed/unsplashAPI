//
//  SettingsViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {

    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var changePasswordButton: UIButton! {
        didSet {
            changePasswordButton.customiseMainActorButton(title: "Change my password", shadow: true)
        }
    }
    @IBOutlet private weak var deletePersistantButton: UIButton! {
        didSet {
            deletePersistantButton.customiseMainActorButton(title: "Delete persistent data", shadow: true)
        }
    }
    @IBOutlet private weak var logOutButton: UIButton! {
        didSet {
            logOutButton.customiseMainActorButton(title: "Log out", shadow: true)
            logOutButton.setAttributedTitle(
                NSAttributedString(
                    string: "Log Out",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.red,
                        NSAttributedString.Key.font: DesignedSystemFonts.button
                    ]
                ),
                for: .normal)
        }
    }
    
    var viewModel: SettingsViewModelProtocol!
    unowned var coordinator: BrowseCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        changePasswordButton.animateButtonWhenTapping()
        // TODO: Move to screen with the changing password
    }
    
    @IBAction func deletePersistentPressed(_ sender: Any) {
        deletePersistantButton.animateButtonWhenTapping()
        let alert = alertMessage(
            title: "Warning!",
            description: "Are you sure that you want to delete all liked images?",
            buttonDefaultTitle: "No",
            buttonDestructiveTitle: "Delete",
            handlerDestructive: { [weak self] _ in
                guard let self else { return }
                self.viewModel.deletePersistentDataPressed()
            },
            handlerDefault: { _ in}
        )
        self.present(alert, animated: true)
        // TODO: Remove all liked images from cored data
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        logOutButton.animateButtonWhenTapping()
        let alert = alertMessage(
            title: "Time to say goodbye?",
            description: "Hope that it was just a misclick...",
            buttonDefaultTitle: "No",
            buttonDestructiveTitle: "Log out",
            handlerDestructive: { [weak self] _ in
                guard let self else { return }
                viewModel.logOutPressed()
                self.dismiss(animated: true)
                coordinator.userdLogOut()
            },
            handlerDefault: { _ in }
        )
        self.present(alert, animated: true)
    }
}
