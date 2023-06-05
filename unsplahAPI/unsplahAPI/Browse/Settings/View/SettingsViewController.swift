//
//  SettingsViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {

    var viewModel: SettingsViewModelProtocol!
    var coordinator: BrowseCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
