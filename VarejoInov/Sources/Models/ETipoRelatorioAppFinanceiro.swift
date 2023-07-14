//
//  ETipoRelatorioAppFinanceiro.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

public enum ETipoRelatorioAppFinanceiro: Int, Codable {
    case nenhum
    case vendaDia
    case vendaHora
    case frmpgto
    case frmpgtoAdmin
}
