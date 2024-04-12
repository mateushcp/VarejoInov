//
//  AuthRequestData.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 17/07/23.
//

import Foundation

struct AuthRequestData: Codable {
    let Codigo: Int
    let Senha: String
    let Perfil: PerfilData
}

struct PerfilData: Codable {
    let Permissoes: [PermData]
}

struct PermData: Codable {
    let Nome: String
}

struct AuthResponse: Codable {
    let Codigo: Int
    let Nome: String
    let Barras: String?
    let Endereco: String?
    let Telefone: String?
    let Celular : String?
    let Senha: String?
    let Biometria: String?
    let Compl: String?
    let HorarioNoturno: String?
    let Atendente: Bool
    let TabelaPreco: String?
    let Perfil: String?
    let Ativo: Bool
    let Empresas: String?
    let UsuarioAlteracao: Int
}

struct ProfileResponseModel: Codable {
    struct Endereco: Codable {
        struct Pais: Codable {
            let Codigo: String
            let Nome: String
        }
        
        let Cep: String
        let Logradouro: String
        let Numero: String
        let Compl: String
        let Bairro: String
        let Municipio: String
        let CodigoMunicipio: Int
        let UF: String
        let Pais: Pais
        
    }
    
    let Codigo: Int
    let Nome: String
    let Fantasia: String
    let CpfCnpj: String
    let IE: String
    let IM: String
    let Site: String
    let Email: String
    let Contato: String
    let Crt: Int
    let Endereco: Endereco
    let Ativo: Bool
    let CodigoMatriz: Int
    let CodigoEstornoCredito: String
    let CodigoCreditoPresumido: String
    let RegimeFederal: Int
    let Telefone: String
    let Celular: String
    
}
