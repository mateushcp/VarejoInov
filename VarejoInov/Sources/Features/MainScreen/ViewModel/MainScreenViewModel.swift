//
//  MainScreenViewModel.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

class MainScreenViewModel {
    weak public var delegate: MainScreenViewModelDelegate?
    
    func sendRequest(startDate: Date?, endDate: Date?, filter: TipoRelatorioAppFinanceiro?, code: Int?) {
        if let subdomain = UserDefaultsManager.shared.subdomain,
           let url = URL(string: "https://\(subdomain).inovautomacao.com.br/api/relatorioappfinanceiro") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            let requestData = RequestData(data1: startDate != nil ? dateFormatter.string(from: startDate!) : dateFormatter.string(from: today),
                                          data2: endDate != nil ? dateFormatter.string(from: endDate!) : dateFormatter.string(from: today),
                                          tipo: filter ?? .VendaDia,
                                          emp: EmpData(codigo: code ?? 1))
            
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
                                DispatchQueue.main.async {
                                    for data in decodedResponse {
                                        print("Value: \(data.value), Label: \(data.label)")
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
        if let subdomain = UserDefaultsManager.shared.subdomain,
           let url = URL(string: "https://\(subdomain).inovautomacao.com.br/api/relatorioappfinanceiro") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let currentDate = getCurrentDate()
            
            let requestData = RequestData(data1: currentDate.data1, data2: currentDate.data2, tipo: .VendaDia, emp: EmpData(codigo: 1))
            
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
