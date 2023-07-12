//
//  SceneDelegate.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var flowController: VarejoInovFlowController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        flowController = VarejoInovFlowController()
        let rootViewController = flowController?.start()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
