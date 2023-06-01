//
//  LikedViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class LikedViewController: UIViewController, LikedViewControllerProtocol {

    var viewModel: LikedViewModelProtocol!
    var coordinator: BrowseCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
