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
