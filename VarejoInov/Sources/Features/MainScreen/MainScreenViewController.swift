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
    private var currentFilter: ETipoRelatorioAppFinanceiro? = .vendaDia
    private var startDate: Date?
    private var endDate: Date?
    
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
        view.backgroundColor = UIColor(red: 230/255, green: 227/255, blue: 227/255, alpha: 1.0)
        navigationController?.navigationBar.isHidden = true
        setupContentView()
        
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: CGFloat(0x87) / 255.0, green: CGFloat(0xA2) / 255.0, blue: CGFloat(0xBE) / 255.0, alpha: 1.0)
        
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
            tabBar.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}

extension MainScreenViewController: MainScreenViewDelegate {
    func setFilterDate(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func getNewChart(startDate: Date?, endDate: Date?) {
        viewModel.sendRequest(startDate: startDate, endDate: endDate, filter: self.currentFilter)
    }
    
    
}

extension MainScreenViewController: MainScreenViewModelDelegate {
    func didReceiveResponseValues(_ responseValues: [ResponseData]) {
        contentView.updateChart(data: responseValues)
    }
    
}

extension MainScreenViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            print("deu bom")
        } else if item.tag == 1 {
            // Carregar o conteúdo para a segunda tab
        } else if item.tag == 2 {
            presentFilters()
        }
        
        tabBar.selectedItem = item
    }
    
    func presentFilters() {
        let alertController = UIAlertController(title: "Filtros", message: "Escolha um filtro:", preferredStyle: .actionSheet)
        
        let salesByDayAction = UIAlertAction(title: "Vendas por Dia", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Vendas por Dia")
            self.viewModel.sendRequest(startDate: self.startDate, endDate: self.endDate, filter: self.currentFilter)
        }
        
        let salesByHourAction = UIAlertAction(title: "Vendas por Hora", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Vendas por Hora")
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            self.viewModel.sendRequest(startDate: today, endDate: today, filter: self.currentFilter)
        }
        
        let paymentMethodsAction = UIAlertAction(title: "Formas de Pagamento", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Formas de Pagamento")
            self.viewModel.sendRequest(startDate: self.startDate, endDate: self.endDate, filter: self.currentFilter)
        }
        
        let paymentMethodsNFAction = UIAlertAction(title: "Formas de Pagamento: NF Admin", style: .default) { _ in
            self.currentFilter = self.handleFilters(filter: "Formas de Pagamento NF Admin")
            self.viewModel.sendRequest(startDate: self.startDate, endDate: self.endDate, filter: self.currentFilter)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(salesByDayAction)
        alertController.addAction(salesByHourAction)
        alertController.addAction(paymentMethodsAction)
        alertController.addAction(paymentMethodsNFAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleFilters(filter: String) -> ETipoRelatorioAppFinanceiro {
        switch filter {
        case "Vendas por Dia":
            return .vendaDia
        case "Vendas por Hora":
            return .vendaHora
        case "Formas de Pagamento":
            return .frmpgto
        case "Formas de Pagamento NF Admin":
            return .frmpgtoAdmin
        default:
            return .vendaDia
        }
        
    }
}

