//
//  VarejoInovFlowController.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit

class VarejoInovFlowController {
    // MARK: - Properties
    private let viewControllerFactory: ViewControllerFactoryProtocol
    private var navigationController: UINavigationController?
    
    // MARK: - Initialization
    public init() {
        self.viewControllerFactory = ViewControllerFactory()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Start Flow
    func start() -> UINavigationController? {
        let startViewController = viewControllerFactory.makeLoginScreenViewController(delegate: self)
        self.navigationController = UINavigationController(rootViewController: startViewController)
        return navigationController
    }
}

extension VarejoInovFlowController: LoginScreenFlowDelegate {
    func navigateToMainScreen(data: [ResponseData]) {
        let nextViewController = viewControllerFactory.makeMainScreenViewController(delegate: self, data: data)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

extension VarejoInovFlowController: MainScreenFlowDelegate {
    func userLoggedOut() {
        if let navigationController = self.navigationController {
            navigationController.viewControllers = []
            
            let loginViewController = viewControllerFactory.makeLoginScreenViewController(delegate: self)
            navigationController.setViewControllers([loginViewController], animated: true)
        }
    }
}
