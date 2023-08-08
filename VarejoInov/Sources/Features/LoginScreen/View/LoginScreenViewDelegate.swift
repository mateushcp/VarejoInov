//
//  LoginScreenViewDelegate.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit

protocol LoginScreenViewDelegate: AnyObject {
    func sendLoginData(user: Int, password: String)
    func presentAlert(_ alertController: UIAlertController)
    func didSetDomain()
}
