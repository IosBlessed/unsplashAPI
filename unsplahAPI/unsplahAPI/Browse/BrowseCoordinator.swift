//
//  BrowseCoordinator.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

final class BrowseCoordinator: BrowseCoordinatorProtocol {

    var navigationController: UINavigationController
    unowned var mainCoordinator: MainCoordinatorProtocol

    init(navigationController: UINavigationController, mainCoordinator: MainCoordinatorProtocol) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    func initializeBrowseProcess() {
        let tabBarViewController = RootTabBarBuilder.build() as? RootTabBarViewController
        navigationController.present(tabBarViewController!, animated: false)
    }
    
    func initializePictureDetails(
        fromNavigationController: UINavigationController?,
        imageObject: UnsplashImage
    ) {
        let pictureDetailsVC = PictureDetailsBuilder.build() as? PictureDetailsViewController
        pictureDetailsVC?.initializeImageSetup(image: imageObject)
        fromNavigationController?.pushViewController(pictureDetailsVC!, animated: true)
    }
    
    func initializeChangePassword(fromNavigationController: UINavigationController?) {
        let changePasswordVC = ChangePasswordBuilder.build() as? ChangePasswordViewController ?? ChangePasswordViewController()
        fromNavigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    func userdLogOut() {
        mainCoordinator.initialStart()
    }
}
