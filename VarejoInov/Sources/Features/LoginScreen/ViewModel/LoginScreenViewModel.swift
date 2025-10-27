//
//  LoginScreenViewModel.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

protocol LoginScreenViewModelDelegate: AnyObject {
    func didReceiveResponseValues(_ responseValues: [ResponseData])
    func loginResul(result: LoginResult)
}

class LoginScreenViewModel {
    
    weak public var delegate: LoginScreenViewModelDelegate?
    
    func sendAuthRequest(login: Int, password: String) {
        AuthAPI.shared.login(loginCode: login, password: password) { result in
            switch result {
            case .success(let token):
                
                KeychainManager.shared.saveCredentials(login: login, password: password, token: token)
                self.delegate?.loginResul(result: .succes)
                
            case .failure(let error):
                print("Erro no login: \(error.localizedDescription)")
                self.delegate?.loginResul(result: .failed)
            }
        }
    }
}
