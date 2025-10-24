//
//  LoginScreenView.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit

class LoginScreenView: UIView {
    public weak var delegate: LoginScreenViewDelegate?
    
    // MARK: - variables
    private var isLoginButtonEnabled: Bool = false {
        didSet {
            loginButton.setEnabled(isLoginButtonEnabled)
        }
    }
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "loginBackground")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 330).isActive = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginField: IconTextField = {
        let field = IconTextField(
            placeholder: "Usuário",
            leftIcon: UIImage(named: "userIcon"),
            keyboardType: .numberPad
        )
        return field
    }()

    private lazy var passwordField: IconTextField = {
        let field = IconTextField(
            placeholder: "Senha",
            leftIcon: UIImage(named: "passwordIcon"),
            isSecure: true
        )
        return field
    }()

    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton(title: "Entrar")
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    let domainButton: SecondaryButton = {
        let button = SecondaryButton(title: "Escolher Empresa", width: 160)
        return button
    }()
    
    // MARK: - setup
    
    init() {
        super.init(frame: .zero)
        setupUI()
        
        setupKeyboardDismissal()
        configureDoneToolbarForKeyboard()
        
        registerForKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error, not implemented")
    }
    // MARK: - private functions
    
    private func configureDoneToolbarForKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        doneToolbar.barStyle = .default
        doneToolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(dismissKeyboard))

        doneToolbar.items = [flexSpace, doneButton]
        loginField.inputAccessoryView = doneToolbar
        passwordField.inputAccessoryView = doneToolbar
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }

    @objc
    private func loginTapped() {
        if UserDefaultsManager.shared.subdomain == nil {
            showCompanyAlert()
        } else {
            delegate?.sendLoginData(user: Int(loginField.text ?? "")!, password: passwordField.text ?? "")
        }
    }
    
    @objc
    private func domainTapped() {
        let alertController = UIAlertController(title: "Digite o domínio da empresa", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Domínio"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let domain = alertController.textFields?.first?.text else { return }
            UserDefaultsManager.shared.subdomain = domain
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        delegate?.presentAlert(alertController)
    }
    
    private func showCompanyAlert() {
        let alert = UIAlertController(title: "Empresa nao definida", message: "Por favor, defina a empresa e tente novamente.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ok", style: .default)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        if let viewController = delegate as? UIViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupButtonIsEnabled() {
        isLoginButtonEnabled = false
        loginField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        let hasUsername = !(loginField.text?.isEmpty ?? true)
        let hasPassword = !(passwordField.text?.isEmpty ?? true)
        isLoginButtonEnabled = hasUsername && hasPassword
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(loginField)
        addSubview(logoView)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(domainButton)
        
        setupConstraints()
        setupButtonIsEnabled()
    }
    
    private func setupConstraints() {
        backgroundView.anchor(
            top: topAnchor,
            leading: safeAreaLayoutGuide.leadingAnchor,
            bottom: bottomAnchor,
            trailing: safeAreaLayoutGuide.trailingAnchor
        )

        loginField.centerY(in: self)
        loginField.anchor(
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        )

        logoView.anchor(
            bottom: loginField.topAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        )
        logoView.centerX(in: self)

        passwordField.anchor(
            top: loginField.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 32, bottom: 0, right: 32)
        )

        domainButton.anchor(
            bottom: loginField.topAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        )
        domainButton.centerX(in: self)

        loginButton.anchor(
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 32, bottom: 48, right: 32)
        )
    }
    
}

extension LoginScreenView {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        // Calcula quanto precisa mover para os campos ficarem visíveis
        let keyboardHeight = keyboardFrame.height
        let moveDistance = -keyboardHeight / 2

        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(translationX: 0, y: moveDistance)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}
