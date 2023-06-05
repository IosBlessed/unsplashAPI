//
//  Constatns.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation
import UIKit

struct Constants {
    static let sanFranciscoBold: UIFont = UIFont(name: "SFProDisplay-Bold", size: 16) ??
                                          UIFont.systemFont(ofSize: 16, weight: .bold)
    static let sanFranciscoRegular: UIFont = UIFont(name: "SFProDisplay-Regular", size: 16) ??
                                             UIFont.systemFont(ofSize: 16, weight: .regular)
    static var authentificationMarginBackgroundImageTop: Double = 0.0
    static let homeScreenBackgroundImageMovementConstant: CGFloat = 280
    static let serverAppName: String = "unsplashAPI.com"
    static let likeHeartAnimationSize = (width: 100.0, height: 90.0)
}
