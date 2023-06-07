//
//  KeyChain.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 30.05.2023.
//
import UIKit
import Security

enum KeychainUserKeys: String {
    case username
    case password
}

enum KeychainError: Error {
    case passwordMissMatch
    case unableToSavePassword
    case unableToProcessRequest
    case unableToUpdatePassword
    case unableToExtractPassword
    case unexpectedPasswordData
    case unableToDeletePassword
}

enum KeychainSuccess {
    case passwordSavedSuccessfully
    case passwordUpdatedSuccessfully
    case passwordDeletedSuccessfully
    case passwordExtractedSuccessfully
}

typealias PasswordDetails = [String: String]

class KeychainService {
    // MARK: - Properties
    private var username = ""
    private var password = Data()
    private var queryForModifications: [String: Any] = [
        kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: Constants.serverAppName
    ]
    // MARK: - Singleton
    static let shared = KeychainService()
    private init() {}
    // MARK: - Create
    func savePassword(
        username: String,
        password: String,
        handler: @escaping (Result<KeychainSuccess, KeychainError>
        ) -> Void ) {
        self.username = username
        self.password = password.data(using: .utf8)!
        do {
            try savePasswordToKeychain()
            handler(.success(.passwordSavedSuccessfully))
        } catch let error as KeychainError {
            handler(.failure(error))
        } catch {
            handler(.failure(.unableToProcessRequest))
        }
    }

    private func savePasswordToKeychain() throws {
        let keychainQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: username,
                                    kSecAttrServer as String: Constants.serverAppName,
                                    kSecValueData as String: password]
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unableToSavePassword }
    }
    // MARK: - Read
    func getPassword(handler: @escaping (Result<PasswordDetails, KeychainError>) -> Void) {
        do {
            let userData = try getPasswordFromKeychain()
            let passwordData = userData?[kSecValueData as String] as? Data ?? Data()
            let userCredentials = [
                KeychainUserKeys.username.rawValue: userData?[kSecAttrAccount as String] as? String ?? "Unknown",
                KeychainUserKeys.password.rawValue: String(data: passwordData, encoding: .utf8) ?? "Unknown"
            ]
            handler(.success(userCredentials))
        } catch let error as KeychainError {
            handler(.failure(error))
        } catch {
            handler(.failure(.unableToProcessRequest))
        }
    }

    private func getPasswordFromKeychain() throws -> [String: Any]? {
        let keychainQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Constants.serverAppName,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var keychainData: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &keychainData)
        guard status != errSecItemNotFound else { throw KeychainError.passwordMissMatch }
        guard status == errSecSuccess else { throw KeychainError.unableToExtractPassword }
        guard let userCredentials = keychainData as? [String: Any]
        else {
            throw KeychainError.unexpectedPasswordData
        }
        return userCredentials
    }
    // MARK: - Update
    func updatePassword(
        newUsername username: String,
        newPassword password: String,
        handler: @escaping (Result <KeychainSuccess, KeychainError>
        ) -> Void) {
        self.username = username
        self.password = password.data(using: .utf8)!
        do {
            try updatePasswordFromKeychain()
            handler(.success(.passwordUpdatedSuccessfully))
        } catch let error as KeychainError {
            handler(.failure(error))
        } catch {
            handler(.failure(.unableToProcessRequest))
        }
    }

    private func updatePasswordFromKeychain() throws {
        let newAttributes: [String: Any] = [
            kSecAttrAccount as String: username,
            kSecValueData as String: password
        ]
        let status = SecItemUpdate(queryForModifications as CFDictionary, newAttributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.passwordMissMatch}
        guard status == errSecSuccess else { throw KeychainError.unableToUpdatePassword }
    }
    // MARK: - Delete
    func deletePassword(handler: @escaping (Result<KeychainSuccess, KeychainError>) -> Void) {
        do {
            try deletePasswordFromKeychain()
            handler(.success(.passwordDeletedSuccessfully))
        } catch let error as KeychainError {
            handler(.failure(error))
        } catch {
            handler(.failure(.unableToProcessRequest))
        }
    }

    private func deletePasswordFromKeychain() throws {
        let status = SecItemDelete(queryForModifications as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.passwordMissMatch}
        guard status == errSecSuccess else { throw KeychainError.unableToDeletePassword }
    }
}
