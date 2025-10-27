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
                
        let savedDomains = UserDefaultsManager.shared.savedDomains()
        for domain in savedDomains {
            let domainAction = UIAlertAction(title: domain, style: .default) { [weak self] _ in
                UserDefaultsManager.shared.subdomain = domain
                self?.contentView.domainButton.setTitle(domain, for: .normal)

            }
            alertController.addAction(domainAction)
        }
        
        let newDomainAction = UIAlertAction(title: "Inserir/Alterar Domínio", style: .default) { [weak self] _ in
            self?.presentNewDomainAlert()
        }
        alertController.addAction(newDomainAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Substitua self.view pela vista apropriada
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Defina as coordenadas apropriadas
            popoverController.permittedArrowDirections = [] // Defina as direções apropriadas do popover
        }
        
        present(alertController, animated: true, completion: nil)
        
        let removeDomainsAction = UIAlertAction(title: "Remover Domínios", style: .destructive) { [weak self] _ in
            self?.presentRemoveDomainsAlert()
        }
        alertController.addAction(removeDomainsAction)
    }
    
    private func presentRemoveDomainsAlert() {
        let alertController = UIAlertController(title: "Remover Domínios", message: "Selecione um domínio para remover:", preferredStyle: .actionSheet)
        
        let savedDomains = UserDefaultsManager.shared.savedDomains()
        
        for domain in savedDomains {
            let domainAction = UIAlertAction(title: domain, style: .default) { [weak self] _ in
                self?.removeDomain(domain)
            }
            alertController.addAction(domainAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }

    private func removeDomain(_ domain: String) {
        UserDefaultsManager.shared.removeDomain(domain)
        if UserDefaultsManager.shared.savedDomains().isEmpty {
            contentView.domainButton.setTitle("Escolher Empresa", for: .normal)
        }
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

}
 
