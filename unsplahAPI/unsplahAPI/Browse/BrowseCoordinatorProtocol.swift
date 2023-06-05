//
//  BrowseCoordinatorProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

protocol BrowseCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    var mainCoordinator: MainCoordinatorProtocol { get set }
    func initializeBrowseProcess()
    func initializePictureDetails(fromNavigationController: UINavigationController?, imageObject: UnsplashImage)
    func userdLogOut()
}
