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
    let data1: String
    let data2: String
    let tipo: ETipoRelatorioAppFinanceiro
    let emp: EmpData
}

public struct EmpData: Codable {
    let codigo: Int
}

public struct ResponseData: Codable {
    let value: Double
    let label: String
}

public enum LoginResult {
    case succes
    case failed
}

struct EmptyRequestBody: Encodable {
    
}
