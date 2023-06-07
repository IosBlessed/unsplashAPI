//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class SettingsViewModel: SettingsViewModelProtocol {
    
    func deletePersistentDataPressed() {
        UnsplashAPI.shared.deletePersistentDataFromMemory()
    }
    
    func logOutPressed() {
        UnsplashAPI.shared.removeUserDetailsFromKeychain()
    }
}
