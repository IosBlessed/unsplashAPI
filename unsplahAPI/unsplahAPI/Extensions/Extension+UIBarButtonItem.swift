//
//  Extension+UIBarButtonItem.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 04.06.2023.
//

import UIKit

extension UIBarButtonItem {
    static func createRightBarButton(
        target: Any?,
        action: Selector,
        imageSystemName: String
    ) -> UIBarButtonItem {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .black
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = true
        barButtonItem.customView?.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        
        return barButtonItem
    }
}
