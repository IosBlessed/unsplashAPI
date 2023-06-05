//
//  BrowseCoordinator.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class BrowseCoordinator: BrowseCoordinatorProtocol {

    unowned var navigationController: UINavigationController
    unowned var mainCoordinator: MainCoordinator

    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    func initializeBrowseProcess() {
        let tabBarViewController = RootTabBarBuilder.build() as? RootTabBarViewController
        navigationController.present(tabBarViewController!, animated: false)
    }

    func userdLogOut() {
    }
}
