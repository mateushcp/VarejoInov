//
//  LoginScreenFlowDelegate.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation

public protocol LoginScreenFlowDelegate: AnyObject {
    func navigateToMainScreen(data: [ResponseData])
    
}
