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
        if let domain = UserDefaultsManager.shared.subdomain {
            viewModel.sendRequest()
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
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    }
    
}
 
