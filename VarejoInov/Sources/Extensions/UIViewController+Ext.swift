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
                KeychainManager.shared.clearCredentials()
                onLogout()
            })

            self.present(alert, animated: true)
        }
    }

    private func reauthenticateWithBiometrics(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard BiometricAuthManager.shared.isBiometricAvailable() else {
            showAlert(title: "Biometria Indisponível", message: "Face ID/Touch ID não está disponível. Faça login novamente.") {
                KeychainManager.shared.clearCredentials()
                onFailure()
            }
            return
        }

        BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
            if success {
                self.reauthenticateUser(onSuccess: onSuccess, onFailure: onFailure)
            } else {
                self.showAlert(title: "Autenticação Falhou", message: "Não foi possível autenticar. Faça login novamente.") {
                    KeychainManager.shared.clearCredentials()
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
                    KeychainManager.shared.saveCredentials(token: token)
                    onSuccess()

                case .failure(let error):
                    self.showAlert(title: "Erro", message: "Não foi possível renovar a sessão. Faça login novamente.") {
                        KeychainManager.shared.clearCredentials()
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
