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
    private let nomeKey = "nome"
    private let cpfCnpjKey = "cpfCnpj"
    private let telefoneKey = "telefone"
    private let enderecoRuaKey = "enderecoRua"
    private let enderecoNumeroKey = "enderecoNumero"
    private let fantasiaKey = "fantasia"
    private let authTokenKey = "authToken"

    private init() {}
    
    var subdomain: String? {
        get {
            return UserDefaults.standard.string(forKey: subdomainKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: subdomainKey)
        }
    }
    
    var nome: String? {
        get {
            return UserDefaults.standard.string(forKey: nomeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nomeKey)
        }
    }
    
    var cpfCnpj: String? {
        get {
            return UserDefaults.standard.string(forKey: cpfCnpjKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: cpfCnpjKey)
        }
    }
    
    var telefone: String? {
        get {
            return UserDefaults.standard.string(forKey: telefoneKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: telefoneKey)
        }
    }
    
    var enderecoRua: String? {
        get {
            return UserDefaults.standard.string(forKey: enderecoRuaKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: enderecoRuaKey)
        }
    }
    
    var enderecoNumero: String? {
        get {
            return UserDefaults.standard.string(forKey: enderecoNumeroKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: enderecoNumeroKey)
        }
    }
    
    var fantasia: String? {
        get {
            return UserDefaults.standard.string(forKey: fantasiaKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: fantasiaKey)
        }
    }

    var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: authTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: authTokenKey)
        }
    }

    func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: authTokenKey)
    }

    func savedDomains() -> [String] {
           if let domains = UserDefaults.standard.array(forKey: "savedDomains") as? [String] {
               return domains
           }
           return []
       }
    
    func addDomain(_ domain: String) {
        var domains = savedDomains()
        domains.append(domain)
        UserDefaults.standard.set(domains, forKey: "savedDomains")
    }
    
    func removeDomain(_ domain: String) {
        var domains = savedDomains()
        if let index = domains.firstIndex(of: domain) {
            domains.remove(at: index)
            UserDefaults.standard.set(domains, forKey: "savedDomains")
        }
    }
    
}
