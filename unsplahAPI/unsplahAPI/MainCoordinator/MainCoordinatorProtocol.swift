//
//  MainCoordinatorProtocol.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 04.06.2023.
//
import UIKit
protocol MainCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    func initialStart()
    func startBrowse()
}
