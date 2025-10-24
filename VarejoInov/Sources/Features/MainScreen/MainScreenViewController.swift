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
    private var currentFilter: TipoRelatorioAppFinanceiro? = .VendaDia
    private var startDate: Date?
    private var endDate: Date?
    private var code: Int?
    
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
        view.backgroundColor = AppColors.background
        navigationController?.navigationBar.isHidden = true
        setupContentView()
        viewModel.getProfileData()
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = AppColors.primary
        tabBar.unselectedItemTintColor = AppColors.textSecondary
        
        let tab1 = UITabBarItem(title: "Faturamento", image: UIImage(named: "sales")?.resized(to: CGSize(width: 25, height: 25)), tag: 0)
        let tab2 = UITabBarItem(title: "Perfil", image: UIImage(named: "profile")?.resized(to: CGSize(width: 25, height: 25)), tag: 1)
        let tab3 = UITabBarItem(title: "Filtros", image: UIImage(named: "filters")?.resized(to: CGSize(width: 25, height: 25)), tag: 2)
        let tab4 = UITabBarItem(title: "Sair", image: UIImage(named: "leave")?.resized(to: CGSize(width: 25, height: 25)), tag: 3)
        
        tabBar.items = [tab1, tab2, tab3, tab4]
        tabBar.delegate = self
        
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
}

extension MainScreenViewController: MainScreenViewDelegate {
    func setFilterDate(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func getNewChart(startDate: Date?, endDate: Date?, code: Int?) {
        viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter, code: code)
        self.code = code
    }
    
    
}

extension MainScreenViewController: MainScreenViewModelDelegate {
    func didReceiveProfileData(_ profileData: ProfileResponseModel) {
        self.contentView.updateCompanyInfo(with: profileData)
    }
    
    func didReceiveResponseValues(_ responseValues: [ResponseData]) {
        DispatchQueue.main.async {
            self.contentView.updateChart(data: responseValues)
        }
    }

    func sessionExpired() {
        handleSessionExpired(
            onRetry: {
                self.viewDidLoad()
            },
            onLogout: {
                self.delegate?.userLoggedOut()
            }
        )
    }

}

extension MainScreenViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            let startDate = self.contentView.selectedStartDate
            let endDate = self.contentView.selectedEndDate
            let code = self.contentView.code
            viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: currentFilter, code: code)
        } else if item.tag == 1 {
            presentProfileModal()
        } else if item.tag == 2 {
            presentFilters()
        } else if item.tag == 3 {
            handleLogout()
        }
        
        tabBar.selectedItem = item
    }
    
    func handleLogout() {
        UserDefaultsManager.shared.clearUserDefaultsProfile()
        KeychainManager.shared.clearCredentials()
        delegate?.userLoggedOut()
    }
    
    
    
    func presentProfileModal() {
        let name = UserDefaultsManager.shared.nome ?? "Nome não disponível"
        let cnpj = UserDefaultsManager.shared.cpfCnpj ?? "CPF/CNPJ não disponível"
        let tel = UserDefaultsManager.shared.telefone ?? "Telefone não disponível"
        let street = UserDefaultsManager.shared.enderecoRua ?? "Endereço não disponível"
        let number = UserDefaultsManager.shared.enderecoNumero ?? ""
        let profileInfo = "Nome: \(name)\nCPF/CNPJ: \(cnpj)\nTelefone: \(tel)\nEndereço: \(street) \(number)"
        
        let alertController = UIAlertController(title: "Perfil", message: profileInfo, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentFilters() {
        let alertController = UIAlertController(title: "Filtros", message: "Escolha um filtro:", preferredStyle: .actionSheet)
        
        let salesByDayAction = UIAlertAction(title: "Vendas por Dia", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Vendas por Dia")
            let startDate = self.contentView.selectedStartDate
            let endDate = self.contentView.selectedEndDate
            let code = self.contentView.code
            self.viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter, code: code)
            self.contentView.shouldShowAxisInVertical = false
        }

        let salesByHourAction = UIAlertAction(title: "Vendas por Hora", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Vendas por Hora")
            let startDate = self.contentView.selectedStartDate
            let endDate = self.contentView.selectedEndDate
            let code = self.contentView.code
            self.viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter, code: code)
            self.contentView.shouldShowAxisInVertical = false
        }

        let paymentMethodsAction = UIAlertAction(title: "Formas de Pagamento", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Formas de Pagamento")
            let startDate = self.contentView.selectedStartDate
            let endDate = self.contentView.selectedEndDate
            let code = self.contentView.code
            self.viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter, code: code)
            self.contentView.shouldShowAxisInVertical = true
        }

        let paymentMethodsNFAction = UIAlertAction(title: "Formas de Pagamento: NF Admin", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Formas de Pagamento NF Admin")
            let startDate = self.contentView.selectedStartDate
            let endDate = self.contentView.selectedEndDate
            let code = self.contentView.code
            self.viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter, code: code)
            self.contentView.shouldShowAxisInVertical = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        if let popoverController = alertController.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) 
               popoverController.permittedArrowDirections = [] 
           }
        alertController.addAction(salesByDayAction)
        alertController.addAction(salesByHourAction)
        alertController.addAction(paymentMethodsAction)
        alertController.addAction(paymentMethodsNFAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleFilters(filter: String) -> TipoRelatorioAppFinanceiro {
        switch filter {
        case "Vendas por Dia":
            return .VendaDia
        case "Vendas por Hora":
            return .VendaHora
        case "Formas de Pagamento":
            return .FormaPagamento
        case "Formas de Pagamento NF Admin":
            return .FormaPagamentoAdmin
        default:
            return .VendaDia
        }
        
    }
}
