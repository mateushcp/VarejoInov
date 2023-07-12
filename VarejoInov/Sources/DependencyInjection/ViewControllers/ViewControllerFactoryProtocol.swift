//
//  ViewControllerFactoryProtocol.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
protocol ViewControllerFactoryProtocol: AnyObject {
    func makeLoginScreenViewController(delegate: LoginScreenFlowDelegate) -> LoginScreenViewController
    func makeMainScreenViewController(delegate: MainScreenFlowDelegate) -> MainScreenViewController
}
