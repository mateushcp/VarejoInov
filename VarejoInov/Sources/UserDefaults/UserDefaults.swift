//
//  UserDefaults.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 17/07/23.
//

import Foundation
import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let subdomainKey = "subdomain"

    private init() {}

    var subdomain: String? {
        get {
            return UserDefaults.standard.string(forKey: subdomainKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: subdomainKey)
        }
    }
}
