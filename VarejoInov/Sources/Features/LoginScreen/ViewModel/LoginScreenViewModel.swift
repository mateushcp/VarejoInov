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
        if let subdomain = UserDefaultsManager.shared.subdomain,
           let url = URL(string: "https://\(subdomain).inovautomacao.com.br/api/auth/acs_app") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let authData = AuthRequestData(codigo: login, senha: password, perfil: PerfilData(lst_perm: [PermData(nome: "apps-financeiro")]))
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(authData)
                request.httpBody = jsonData
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    if (200..<300).contains(httpResponse.statusCode) {
                        self.delegate?.loginResul(result: .succes)
                    } else {
                        self.delegate?.loginResul(result: .failed)
                    }
                }
                
                task.resume()
            } catch {
                print("Error encoding request data: \(error.localizedDescription)")
            }
        } else {
            print("Subdomain not found in UserDefaults.")
        }
    }
    
    func sendRequest() {
        if let subdomain = UserDefaultsManager.shared.subdomain,
           let url = URL(string: "https://\(subdomain).inovautomacao.com.br/api/relatorioappfinanceiro") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let currentDate = getCurrentDate()
            
            let requestData = RequestData(data1: currentDate.data1, data2: currentDate.data2, tipo: .vendaDia, emp: EmpData(codigo: 1))
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(requestData)
                request.httpBody = jsonData
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        if let responseData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedResponse = try decoder.decode([ResponseData].self, from: responseData)
                                self.delegate?.didReceiveResponseValues(decodedResponse)
                                for data in decodedResponse {
                                    print("Value: \(data.value), Label: \(data.label)")
                                }
                            } catch {
                                print("Error decoding response data: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Request failed with status code: \(httpResponse.statusCode)")
                    }
                }
                
                task.resume()
            } catch {
                print("Error encoding request data: \(error.localizedDescription)")
            }
        } else {
            print("Subdomain not found in UserDefaults.")
        }
    }
    
    func getProfileData() {
        if let subdomain = UserDefaultsManager.shared.subdomain,
           let url = URL(string: "https://\(subdomain).inovautomacao.com.br/api/empresa/lst") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let emptyBody = EmptyRequestBody()
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(emptyBody)
                request.httpBody = jsonData
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let responseData = data else {
                        print("No response data")
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let profileResponse = try decoder.decode([ProfileResponseModel].self, from: responseData)
                        
                        if let profile = profileResponse.first {
                            UserDefaultsManager.shared.nome = profile.nome
                            UserDefaultsManager.shared.cpfCnpj = profile.cpfcnpj
                            UserDefaultsManager.shared.telefone = profile.endereco.tel2
                            UserDefaultsManager.shared.enderecoRua = profile.endereco.logradouro
                            UserDefaultsManager.shared.enderecoNumero = profile.endereco.nro
                        }
                    } catch {
                        print("Error decoding response data: \(error.localizedDescription)")
                    }
                }
                
                task.resume()
            } catch {
                print("Error encoding request data: \(error.localizedDescription)")
            }
        } else {
            print("Subdomain not found in UserDefaults.")
        }
    }
    
    func getCurrentDate() -> (data1: String, data2: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let data2 = dateFormatter.string(from: currentDate)
        
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!
        let data1 = dateFormatter.string(from: threeDaysAgo)
        
        return (data1, data2)
    }
}
