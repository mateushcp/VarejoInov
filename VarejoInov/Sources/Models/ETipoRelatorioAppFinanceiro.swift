//
//  TipoRelatorioAppFinanceiro.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

public enum TipoRelatorioAppFinanceiro: Int, Codable {
    case Nenhum
    case VendaDia
    case VendaHora
    case FormaPagamento
    case FormaPagamentoAdmin
}
