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
    
}
