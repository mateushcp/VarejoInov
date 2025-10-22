//
//  MainScreenViewModel.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

class MainScreenViewModel {
    weak public var delegate: MainScreenViewModelDelegate?
    
    func getProfileData() {
        let credentials = KeychainManager.shared.getCredentials()

        if let baseURL = AuthAPI.baseURL,
            let url = URL(string: "\(baseURL)/api/empresa/lst") {

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let emptyBody = EmptyRequestBody()

            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(emptyBody)
                request.httpBody = jsonData

                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                if let token = credentials?.token {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
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
                            ProfileData.shared.profiles = profileResponse

                            UserDefaultsManager.shared.nome = profile.Nome
                            UserDefaultsManager.shared.cpfCnpj = profile.CpfCnpj
                            UserDefaultsManager.shared.telefone = profile.Celular
                            UserDefaultsManager.shared.enderecoRua = profile.Endereco.Logradouro
                            UserDefaultsManager.shared.enderecoNumero = profile.Endereco.Numero
                            UserDefaultsManager.shared.fantasia = profile.Fantasia

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
    
    func sendRequest(startDate: Date?, endDate: Date?, filter: TipoRelatorioAppFinanceiro?, code: Int?) {
        let credentials = KeychainManager.shared.getCredentials()

        if let baseURL = AuthAPI.baseURL,
            let url = URL(string: "\(baseURL)/api/relatorioappfinanceiro") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            let requestData = RequestData(DataInicial: startDate != nil ? dateFormatter.string(from: startDate!) : dateFormatter.string(from: today),
                                          DataFinal: endDate != nil ? dateFormatter.string(from: endDate!) : dateFormatter.string(from: today),
                                          Tipo: filter ?? .VendaDia,
                                          Empresa: code ?? 1)

            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(requestData)
                request.httpBody = jsonData

                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                if let token = credentials?.token {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        return
                    }

                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            self.delegate?.sessionExpired()
                        }
                        return
                    }

                    if httpResponse.statusCode == 200 {
                        if let responseData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedResponse = try decoder.decode([ResponseData].self, from: responseData)
                                DispatchQueue.main.async {
                                    for data in decodedResponse {
                                        print("Value: \(data.Value), Label: \(data.Label), Clientes: \(data.NumeroCliente)")
                                        self.delegate?.didReceiveResponseValues(decodedResponse)
                                    }
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
        }
    }
    
    func sendDefaultSalesRequest() {
        let credentials = KeychainManager.shared.getCredentials()

        if let baseURL = AuthAPI.baseURL,
           let url = URL(string: "\(baseURL)/api/relatorioappfinanceiro") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let currentDate = getCurrentDate()
            
            let requestData = RequestData(DataInicial: currentDate.data1, DataFinal: currentDate.data2, Tipo: .VendaDia, Empresa: 1)

            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(requestData)
                request.httpBody = jsonData

                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                if let token = credentials?.token {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        return
                    }

                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            self.delegate?.sessionExpired()
                        }
                        return
                    }

                    if httpResponse.statusCode == 200 {
                        if let responseData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedResponse = try decoder.decode([ResponseData].self, from: responseData)
                                self.delegate?.didReceiveResponseValues(decodedResponse)
                                for data in decodedResponse {
                                    print("Value: \(data.Value), Label: \(data.Label)")
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
    
    func getCurrentDate() -> (data1: String, data2: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let data2 = dateFormatter.string(from: currentDate)
        
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        let data1 = dateFormatter.string(from: threeDaysAgo)
        
        return (data1, data2)
    }
    
}
