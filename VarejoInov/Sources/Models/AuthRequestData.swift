//
//  AuthRequestData.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 17/07/23.
//

import Foundation

struct AuthRequestData: Codable {
    let codigo: Int
    let senha: String
    let perfil: PerfilData
}

struct PerfilData: Codable {
    let lst_perm: [PermData]
}

struct PermData: Codable {
    let nome: String
}

struct AuthResponse: Codable {
    let codigo: Int
    let nome: String
    let barras: String?
    let senha: String?
    let endereco: String?
    let bio: String?
    let compl: String?
    let perfil: String?
    let hr_noturno: String?
    let atend: Bool
    let tbpr: String?
    let ativo: Bool
    let lst_emp: String?
    let usr_alt: Int
}

struct ProfileResponseModel: Codable {
    struct Endereco: Codable {
        struct Pais: Codable {
            let codigo: String
            let nome: String
        }
        
        let cep: String
        let logradouro: String
        let nro: String
        let compl: String
        let bairro: String
        let municipio: String
        let municipio_codigo: Int
        let uf: String
        let tel1: String
        let tel2: String
        let pais: Pais
    }
    
    let codigo: Int
    let nome: String
    let fantasia: String
    let cpfcnpj: String
    let ie: String
    let im: String
    let site: String
    let email: String
    let contato: String
    let crt: Int
    let endereco: Endereco
    let ativo: Bool
    let codigo_matriz: Int
    let codigo_estorno_credito: String
    let codigo_credito_presumido: String
}
