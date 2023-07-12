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
        imageView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 360).isActive = true
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
        field.backgroundColor = .white
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
    
    // MARK: - setup
    
    init() {
        super.init(frame: .zero)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error, not implemented")
    }
    // MARK: - private functions
    
    @objc
    private func togglePasswordVisibility(sender: UIButton) {
        sender.isSelected.toggle()
        passwordField.isSecureTextEntry.toggle()
    }
    
    @objc
    private func loginTapped() {
        delegate?.didTapLogin()
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(loginField)
        addSubview(logoView)
        addSubview(passwordField)
        addSubview(loginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: 90),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            loginField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loginField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            loginField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 15),
            passwordField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            
        ])
        
    }
    
}
