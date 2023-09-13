//
//  LoginScreenViewController.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import UIKit

class LoginScreenViewController: UIViewController {
    private let contentView: LoginScreenView
    private let viewModel: LoginScreenViewModel
    private var responseValues: [ResponseData] = []
    private var user: Int?
    private var passwordTyped: String?
    public weak var delegate: LoginScreenFlowDelegate?
    
    init(contentView: LoginScreenView, delegate: LoginScreenFlowDelegate, viewModel: LoginScreenViewModel) {
        self.contentView = contentView
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        viewModel.delegate = self
        setupContentView()
        setupNavBar()
        handleFirstAcces()
    }
    
    private func handleFirstAcces() {
        if let domain = UserDefaultsManager.shared.subdomain {
            viewModel.sendRequest()
        }
        
        if UserDefaultsManager.shared.nome == nil {
            viewModel.getProfileData()
        }
    }
    
    private func handleLoginResult(result: LoginResult) {
        DispatchQueue.main.async {
            switch result {
            case .succes:
                self.delegate?.navigateToMainScreen(data: self.responseValues)
                
            case .failed:
                let alertController = UIAlertController(title: "Erro de login", message: "As credenciais digitadas estão incorretas. Por favor, tente novamente.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        if let currentDomain = UserDefaultsManager.shared.subdomain {
               contentView.domainButton.setTitle(currentDomain, for: .normal)
           }
        contentView.domainButton.addTarget(self, action: #selector(presentDomainOptions), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func presentDomainOptions() {
        let alertController = UIAlertController(title: "Escolher Domínio", message: nil, preferredStyle: .actionSheet)
        
        // Adicione ação para escolher o domínio atual
        if let currentDomain = UserDefaultsManager.shared.subdomain {
            let currentDomainAction = UIAlertAction(title: "Domínio Atual: \(currentDomain)", style: .default, handler: nil)
            alertController.addAction(currentDomainAction)
        }
        
        // Adicione ação para cada domínio cadastrado
        let savedDomains = UserDefaultsManager.shared.savedDomains() // Implemente essa função em UserDefaultsManager
        for domain in savedDomains {
            let domainAction = UIAlertAction(title: domain, style: .default) { [weak self] _ in
                UserDefaultsManager.shared.subdomain = domain
                self?.contentView.domainButton.setTitle(domain, for: .normal)
                self?.viewModel.sendRequest()
                self?.viewModel.getProfileData()
            }
            alertController.addAction(domainAction)
        }
        
        // Adicione ação para inserir um novo domínio
        let newDomainAction = UIAlertAction(title: "Inserir/Alterar Domínio", style: .default) { [weak self] _ in
            self?.presentNewDomainAlert()
        }
        alertController.addAction(newDomainAction)
        
        // Adicione ação para cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentNewDomainAlert() {
        let alertController = UIAlertController(title: "Inserir Novo Domínio", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Domínio"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let domain = alertController.textFields?.first?.text else { return }
            UserDefaultsManager.shared.subdomain = domain
            UserDefaultsManager.shared.addDomain(domain)
            self?.contentView.domainButton.setTitle(domain, for: .normal)
            self?.viewModel.sendRequest()
            self?.viewModel.getProfileData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }


    
}

extension LoginScreenViewController: LoginScreenViewDelegate {
    func sendLoginData(user: Int, password: String) {
        self.viewModel.sendAuthRequest(login: user, password: password)
    }
    
    func presentAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginScreenViewController: LoginScreenViewModelDelegate {
    
    func loginResul(result: LoginResult) {
        handleLoginResult(result: result)
    }
    
    func didReceiveResponseValues(_ responseValues: [ResponseData]) {
        self.responseValues = responseValues
    }
    
    func didSetDomain() {
        viewModel.sendRequest()
        viewModel.getProfileData()
    }
    
}
 
