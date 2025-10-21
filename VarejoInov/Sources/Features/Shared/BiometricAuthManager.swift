//
//  BiometricAuthManager.swift
//  VarejoInov
//
//  Created by Samuel França on 20/10/25.
//

import Foundation
import LocalAuthentication

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    private init() {}

    // Verifica se biometria está disponível
    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:
&error)
    }

    // Autentica com Face ID/Touch ID
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        let reason = "Autentique-se para renovar sua sessão"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:
reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

}
