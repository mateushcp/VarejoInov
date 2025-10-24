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
    private let userToken = "userToken"

    
    func saveCredentials(login: Int? = nil, password: String? = nil, token: String? = nil) {
        if let login {
            saveToKeychain(key: userLoginKey, value: String(login))
        }
        if let password {
            saveToKeychain(key: userPasswordKey, value: password)
        }
        if let token {
            saveToKeychain(key: userToken, value: token)
        }
    }

    func getCredentials() -> (login: Int, password: String, token: String)? {
        guard let loginString = getFromKeychain(key: userLoginKey),
              let login = Int(loginString),
              let password = getFromKeychain(key: userPasswordKey),
              let token = getFromKeychain(key: userToken) else {
            return nil
        }
        return (login, password, token)
    }

    func clearCredentials() {
        deleteFromKeychain(key: userLoginKey)
        deleteFromKeychain(key: userPasswordKey)
        deleteFromKeychain(key: userToken)
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

        SecItemDelete(query as CFDictionary)

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
