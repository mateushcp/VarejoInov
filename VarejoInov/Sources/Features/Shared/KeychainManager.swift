//
//  KeychainManager.swift
//  VarejoInov
//
//  Created by Samuel França on 20/10/25.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    private let service = "com.varejoinov.app"
    private let userLoginKey = "userLogin"
    private let userPasswordKey = "userPassword"
    private let userTempTokenKey = "userTempToken"

    func saveTempToken(_ token: String) {
        saveToKeychain(key: userTempTokenKey, value: token)
    }
    
    func getTempToken() -> String? {
        guard let tempToken = getFromKeychain(key: userTempTokenKey) else {
            return nil
        }
        return tempToken
    }
    
    // Salvar credenciais
    func saveCredentials(login: Int, password: String) {
        saveToKeychain(key: userLoginKey, value: String(login))
        saveToKeychain(key: userPasswordKey, value: password)
    }

    // Recuperar credenciais
    func getCredentials() -> (login: Int, password: String)? {
        guard let loginString = getFromKeychain(key: userLoginKey),
              let login = Int(loginString),
              let password = getFromKeychain(key: userPasswordKey) else {
            return nil
        }
        return (login, password)
    }

    // Limpar credenciais
    func clearCredentials() {
        deleteFromKeychain(key: userLoginKey)
        deleteFromKeychain(key: userPasswordKey)
    }

    // MARK: - Keychain Operations

    private func saveToKeychain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Delete existing item
        SecItemDelete(query as CFDictionary)

        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }

    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
