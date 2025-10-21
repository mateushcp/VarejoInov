//
//  BiometricAuthManager.swift
//  VarejoInov
//
//  Created by Samuel França on 21/10/25.
//

import UIKit

extension UIViewController {
    func handleSessionExpired(onRetry: @escaping () -> Void, onLogout: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Sessão Expirada",
                message: "Sua sessão expirou. Deseja autenticar novamente?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Tentar Novamente", style: .default) { _ in
                self.reauthenticateWithBiometrics(onSuccess: onRetry, onFailure: onLogout)
            })

            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                UserDefaultsManager.shared.clearAuthToken()
                onLogout()
            })

            self.present(alert, animated: true)
        }
    }

    private func reauthenticateWithBiometrics(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        // Verifica se biometria está disponível
        guard BiometricAuthManager.shared.isBiometricAvailable() else {
            showAlert(title: "Biometria Indisponível", message: "Face ID/Touch ID não está disponível. Faça login novamente.") {
                UserDefaultsManager.shared.clearAuthToken()
                onFailure()
            }
            return
        }

        // Solicita autenticação biométrica
        BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
            if success {
                // Biometria aprovada - re-autenticar via API
                self.reauthenticateUser(onSuccess: onSuccess, onFailure: onFailure)
            } else {
                self.showAlert(title: "Autenticação Falhou", message: "Não foi possível autenticar. Faça login novamente.") {
                    UserDefaultsManager.shared.clearAuthToken()
                    onFailure()
                }
            }
        }
    }

    private func reauthenticateUser(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        AuthAPI.shared.reauthenticateWithStoredCredentials { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    UserDefaultsManager.shared.authToken = token
                    print("✅ Token renovado com sucesso via biometria")
                    onSuccess()

                case .failure(let error):
                    print("❌ Erro ao renovar token: \(error.localizedDescription)")
                    self.showAlert(title: "Erro", message: "Não foi possível renovar a sessão. Faça login novamente.") {
                        UserDefaultsManager.shared.clearAuthToken()
                        onFailure()
                    }
                }
            }
        }
    }

    private func showAlert(title: String, message: String, onDismiss: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                onDismiss()
            })
            self.present(alert, animated: true)
        }
    }
}
