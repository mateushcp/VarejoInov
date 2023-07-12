//
//  LoginScreenViewController.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import UIKit

class LoginScreenViewController: UIViewController {
    private let contentView: LoginScreenView
    public weak var delegate: LoginScreenFlowDelegate?
    
    init(contentView: LoginScreenView, delegate: LoginScreenFlowDelegate) {
        self.contentView = contentView
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        setupContentView()
        setupNavBar()
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
    func didTapLogin() {
        delegate?.navigateToMainScreen()
    }
    
}
