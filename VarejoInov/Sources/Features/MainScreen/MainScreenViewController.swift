//
//  MainScreenViewController.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation

import UIKit

class MainScreenViewController: UIViewController {
    private let contentView: MainScreenView
    private let viewModel: MainScreenViewModel
    weak var delegate: MainScreenFlowDelegate?
    
    init(contentView: MainScreenView, delegate: MainScreenFlowDelegate, viewModel: MainScreenViewModel) {
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
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupContentView()
        
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

extension MainScreenViewController: MainScreenViewDelegate {
    func getNewChart(startDate: Date?, endDate: Date?) {
        viewModel.sendRequest(startDate: startDate, endDate: endDate)
    }
    
    
}

extension MainScreenViewController: MainScreenViewModelDelegate {
    func didReceiveResponseValues(_ responseValues: [ResponseData]) {
        contentView.updateChart(data: responseValues)
    }
    
}
