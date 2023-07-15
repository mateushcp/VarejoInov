//
//  MainScreenViewModel.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

class MainScreenViewModel {
    weak public var delegate: MainScreenViewModelDelegate?
    
    func sendRequest(startDate: Date?, endDate: Date?) {
        let url = URL(string: "https://padariaaraujols.inovautomacao.com.br/api/relatorioappfinanceiro")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let requestData = RequestData(data1: startDate != nil ? dateFormatter.string(from: startDate!) : "",
                                      data2: endDate != nil ? dateFormatter.string(from: endDate!) : "",
                                      tipo: .vendaDia,
                                      emp: EmpData(codigo: 1))

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
