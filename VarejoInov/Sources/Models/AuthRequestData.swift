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
