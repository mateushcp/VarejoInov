//
//  RequestData.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

public struct Carro {
    
}

public struct RequestData: Codable {
    let DataInicial: String
    let DataFinal: String
    let Tipo: TipoRelatorioAppFinanceiro
    let Empresa: Int
}

public struct ResponseData: Codable {
    let Value: Double
    let Label: String
    let NumeroCliente: Int?
}

public enum LoginResult {
    case succes
    case failed
}

struct EmptyRequestBody: Encodable {
    
}
