//
//  ObservableObject.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 29.05.2023.
//

import Foundation

final class Observable <T> {
    // MARK: - Properties
    private var notifyListenerTimer: Timer?
    private var triggerChanges: ((T) -> Void)?
    var observedObject: T {
        didSet {
            notifyListenerTimer?.invalidate()
            notifyListenerTimer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(pingListener),
                userInfo: nil,
                repeats: false
            )
        }
    }
    // MARK: - Lifecycle
    init(_ value: T) {
        self.observedObject = value
    }
    // MARK: - Behaviour
    func bind(completion: @escaping (T) -> Void) {
        triggerChanges = completion
    }
    // MARK: - Selectors
    @objc func pingListener() {
        triggerChanges?(observedObject)
    }
}
