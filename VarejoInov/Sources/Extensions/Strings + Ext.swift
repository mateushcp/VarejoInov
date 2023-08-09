//
//  Strings + Ext.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 09/08/23.
//

import Foundation
import UIKit

extension String {
    func formatCPFCNPJ(_ cpfcnpj: String) -> String {
        let formattedCPFCNPJ: String
        if cpfcnpj.count == 11 {
            // Format as CPF
            let cpfPart1 = cpfcnpj.prefix(3)
            let cpfPart2 = cpfcnpj[cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 3)..<cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 6)]
            let cpfPart3 = cpfcnpj[cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 6)..<cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 9)]
            let cpfPart4 = cpfcnpj.suffix(2)
            formattedCPFCNPJ = "\(cpfPart1).\(cpfPart2).\(cpfPart3)-\(cpfPart4)"
        } else if cpfcnpj.count == 14 {
            // Format as CNPJ
            let cnpjPart1 = cpfcnpj.prefix(2)
            let cnpjPart2 = cpfcnpj[cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 2)..<cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 5)]
            let cnpjPart3 = cpfcnpj[cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 5)..<cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 8)]
            let cnpjPart4 = cpfcnpj[cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 8)..<cpfcnpj.index(cpfcnpj.startIndex, offsetBy: 12)]
            let cnpjPart5 = cpfcnpj.suffix(2)
            formattedCPFCNPJ = "\(cnpjPart1).\(cnpjPart2).\(cnpjPart3)/\(cnpjPart4)-\(cnpjPart5)"
        } else {
            // Invalid length, return original value
            formattedCPFCNPJ = cpfcnpj
        }
        return formattedCPFCNPJ
    }
}
