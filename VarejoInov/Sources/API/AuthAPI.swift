//
//  BiometricAuthManager.swift
//  VarejoInov
//
//  Created by Samuel França on 21/10/25.
//

import Foundation

class AuthAPI {
    static let shared = AuthAPI()
    static var baseURL: String? {
          guard let subdomain = UserDefaultsManager.shared.subdomain else { return nil }
          return "https://\(subdomain).inovautomacao.com.br"
      }

    private init() {}

    func login(loginCode: Int, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let baseURL = AuthAPI.baseURL,
              let url = URL(string: "\(baseURL)/api/auth/Login") else {
            completion(.failure(NSError(domain: "AuthAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Subdomain inválido"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let authData = AuthRequestData(
            Codigo: loginCode,
            Senha: password,
            Perfil: PerfilData(Permissoes: [PermData(Nome: "apps-financeiro")])
        )

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(authData)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "AuthAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida"])))
                    return
                }

                if (200..<300).contains(httpResponse.statusCode) {
                    if let data = data, let token = String(data: data, encoding: .utf8) {
                        let cleanToken = token.trimmingCharacters(in: .whitespacesAndNewlines)
                            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        completion(.success(cleanToken))
                    } else {
                        completion(.failure(NSError(domain: "AuthAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token não encontrado"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "AuthAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Login falhou"])))
                }
            }

            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    func reauthenticateWithStoredCredentials(completion: @escaping (Result<String, Error>) -> Void) {
        guard let credentials = KeychainManager.shared.getCredentials() else {
            completion(.failure(NSError(domain: "AuthAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Credenciais não encontradas"])))
            return
        }

        login(loginCode: credentials.login, password: credentials.password, completion: completion)
    }
}
