//
//  ViewControllerFactory.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    func makeLoginScreenViewController(delegate: LoginScreenFlowDelegate) -> LoginScreenViewController {
        let contentView = LoginScreenView()
        let viewController = LoginScreenViewController(contentView: contentView, delegate: delegate)
        
        return viewController
    }
    
    func makeMainScreenViewController(delegate: MainScreenFlowDelegate) -> MainScreenViewController {
        let contentView = MainScreenView()
        let viewController = MainScreenViewController(contentView: contentView, delegate: delegate)
        
        return viewController
    }
}
