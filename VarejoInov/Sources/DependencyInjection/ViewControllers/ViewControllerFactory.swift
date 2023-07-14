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
        let viewModel = LoginScreenViewModel()
        let viewController = LoginScreenViewController(contentView: contentView, delegate: delegate, viewModel: viewModel)
        
        return viewController
    }
    
    func makeMainScreenViewController(delegate: MainScreenFlowDelegate, data: [ResponseData]) -> MainScreenViewController {
        let contentView = MainScreenView(data: data)
        let viewModel = MainScreenViewModel()
        let viewController = MainScreenViewController(contentView: contentView, delegate: delegate, viewModel: viewModel)
        
        return viewController
    }
}
