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
            loginButton.isEnabled = isLoginButtonEnabled
            loginButton.backgroundColor = isLoginButtonEnabled ? UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0) : UIColor(red: 218/255, green: 221/255, blue: 223/255, alpha: 1.0)
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
    
    private let loginField: UITextField = {
        let field = UITextField()
        field.heightAnchor.constraint(equalToConstant: 56).isActive = true
        field.layer.cornerRadius = 16
        field.textAlignment = .left
        field.placeholder = "Usuário"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        field.attributedPlaceholder = NSAttributedString(string: "Usuário", attributes: placeholderAttributes)
        field.textColor = .black
        field.tintColor = .black
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        let iconImageView = UIImageView(image: UIImage(named: "userIcon"))
        iconImageView.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 8, y: 0, width: 24, height: 56)
        iconContainerView.addSubview(iconImageView)
        field.leftView = iconContainerView
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.heightAnchor.constraint(equalToConstant: 56).isActive = true
        field.layer.cornerRadius = 16
        field.textAlignment = .left
        field.placeholder = "Senha"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        field.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: placeholderAttributes)
        field.backgroundColor = .white
        field.textColor = .black
        field.tintColor = .black
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        let iconImageView = UIImageView(image: UIImage(named: "passwordIcon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 8, y: 0, width: 24, height: 56)
        iconImageView.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        iconContainerView.addSubview(iconImageView)
        field.leftView = iconContainerView
        field.leftViewMode = .always
        
        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 56))
        field.rightView = rightContainerView
        field.rightViewMode = .always
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "eyeClosedIcon"), for: .normal)
        eyeButton.setImage(UIImage(named: "eyeOpenIcon"), for: .selected)
        eyeButton.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        eyeButton.frame = CGRect(x: -8, y: 16, width: 24, height: 24)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        rightContainerView.addSubview(eyeButton)
        
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Entrar", for: .normal)
        button.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let domainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Escolher Empresa", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.setTitleColor(UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0), for: .normal)
//        button.addTarget(self, action: #selector(domainTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(dismissKeyboard))
        doneToolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
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
    private func togglePasswordVisibility(sender: UIButton) {
        sender.isSelected.toggle()
        passwordField.isSecureTextEntry.toggle()
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
            self?.delegate?.didSetDomain()
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
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoView.bottomAnchor.constraint(equalTo: loginField.topAnchor, constant: -16),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            loginField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loginField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            loginField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 15),
            passwordField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            domainButton.bottomAnchor.constraint(equalTo: loginField.topAnchor, constant: -24),
            domainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            
        ])
        
    }
    
}

extension LoginScreenView {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y = -keyboardSize.height / 2
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.frame.origin.y = 0
    }
}
