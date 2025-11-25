//
//  File.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit
import DGCharts

class MainScreenView: UIView {
    public weak var delegate: MainScreenViewDelegate?
    var responseValues: [ResponseData] = []
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    private var totalValue: Double?
    var code: Int = 1
    var shouldShowAxisInVertical: Bool = false
    private var numberOfClients: [Int]? {
        didSet {
            updateNumberOfAndTicketValue()
        }
    }
    
    // MARK: - Variables
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mainBackground")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Bem-vindo!"
        label.textColor = AppColors.primary
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameText: UILabel = {
        let label = UILabel()
        let fantasyName = UserDefaultsManager.shared.fantasia ?? ""
        label.text = "\(fantasyName) ▼ "
        label.textColor = AppColors.primary
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let billingText: UILabel = {
        let label = UILabel()
        label.text = "Faturamento"
        label.textColor = AppColors.primary
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Empresa: "
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "Periodo: "
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalGeneralLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Geral: "
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let numberOfClientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nº.Clientes/Ticket Médio: "
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let numberOfAndTicketValue: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let companyNameLabelValue: UILabel = {
        let label = UILabel()
        let cnpj = UserDefaultsManager.shared.cpfCnpj ?? "CPF/CNPJ não disponível"
        label.text = cnpj.formatCPFCNPJ(cnpj)
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalGeneralLabelValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = AppColors.primaryLight
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let picker1 = StyledDatePicker(date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date())

    let picker2 = StyledDatePicker(date: Date())
    
    private let barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 16)
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .white
        chartView.leftAxis.labelTextColor = .white
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.barData?.setValueTextColor(.white)
        chartView.barData?.barWidth = 60.0
        chartView.doubleTapToZoomEnabled = false
        
        return chartView
    }()
    
    // MARK: - Setup
    
    init(data: [ResponseData]) {
        super.init(frame: .zero)
        setupUI(data: data)
        calculateValue(data: data)
        self.selectedStartDate = getCurrentDate().data1
        self.selectedEndDate = getCurrentDate().data2
        numberOfClients = data.compactMap { $0.NumeroCliente }
        let totalClientsInPeriod = numberOfClients?.reduce(0, +) ?? 0
        if totalClientsInPeriod > 0 {
            let ticketValue = totalValue! / Double(totalClientsInPeriod)
            let formattedTicketValue = String(format: "%.2f", ticketValue)
            numberOfAndTicketValue.text = "\(totalClientsInPeriod) / \(formattedTicketValue)"
        } else {
            numberOfAndTicketValue.text = "N/A"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error, not implemented")
    }
    
    func getCurrentDate() -> (data1: Date, data2: Date) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let data2 = currentDate
        let data1 = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        
        return (data1, data2)
    }
    
    // MARK: - Private Functions
    
    private func calculateValue(data: [ResponseData]) {
        var totalValue: Double = 0
        
        for entry in data {
            totalValue += entry.Value
        }
        
        self.totalValue = totalValue
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "R$"
        numberFormatter.locale = Locale(identifier: "pt_BR")
        
        if let formattedTotalValue = numberFormatter.string(from: NSNumber(value: totalValue)) {
            totalGeneralLabelValue.text = formattedTotalValue
        }
    }
    
    private func setupBarChartData(data: [ResponseData]) {
        var days: [String] = []
        var sales: [Double] = []
        
        for data in data {
            var dayLabel = data.Label
            
            if dayLabel == "Cartão Crédito" {
                dayLabel = "Credito"
            } else if dayLabel == "Cartão Débito" {
                dayLabel = "Débito"
            } else if dayLabel == "Caderneta" {
                dayLabel = "Caderno"
            }
            
            let components = dayLabel.split(separator: "/")
            if let day = components.first {
                days.append(String(day))
            } else {
                days.append(dayLabel)
            }
            sales.append(data.Value)
        }
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<days.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: sales[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [AppColors.accent]
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 8, weight: .bold)
        chartDataSet.valueTextColor = .white
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartData.isHighlightEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        xAxis.labelCount = days.count
        
        barChartView.notifyDataSetChanged()
    }
    
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == picker1 {
            selectedStartDate = sender.date
        } else if sender == picker2 {
            selectedEndDate = sender.date
        }
        
        if selectedEndDate != nil {
            delegate?.getNewChart(startDate: selectedStartDate, endDate: selectedEndDate, code: self.code)
            delegate?.setFilterDate(startDate: selectedStartDate, endDate: selectedEndDate)
        }
    }
    
    private func updateNumberOfAndTicketValue() {
        guard let numberOfClients = numberOfClients else {
            numberOfAndTicketValue.text = ""
            return
        }
        
        let sum = numberOfClients.reduce(0, +)
        numberOfAndTicketValue.text = "\(sum)"
    }
    
    private func setupGestures() {
        picker1.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker2.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        nameText.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        nameText.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupUI(data: [ResponseData]) {
        addSubview(backgroundView)
        addSubview(barChartView)
        addSubview(circleView)
        addSubview(welcomeText)
        addSubview(nameText)
        circleView.addSubview(billingText)
        circleView.addSubview(companyNameLabel)
        circleView.addSubview(periodLabel)
        circleView.addSubview(totalGeneralLabel)
        circleView.addSubview(companyNameLabelValue)
        circleView.addSubview(totalGeneralLabelValue)
        circleView.addSubview(numberOfClientsLabel)
        circleView.addSubview(numberOfAndTicketValue)
        circleView.addSubview(welcomeText)
        addSubview(picker1)
        addSubview(picker2)
        
        setupBarChartData(data: data)
        setupConstraints()
        setupGestures()
        
    }
    
    private func setupConstraints() {
        // Background
        backgroundView.anchor(
            top: topAnchor,
            leading: safeAreaLayoutGuide.leadingAnchor,
            bottom: bottomAnchor,
            trailing: safeAreaLayoutGuide.trailingAnchor
        )

        // Header
        welcomeText.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 34, left: 20, bottom: 0, right: 0)
        )

        nameText.anchor(
            top: welcomeText.bottomAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        )

        // Circle View (card)
        circleView.anchor(
            top: nameText.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 18, bottom: 0, right: 18),
            size: CGSize(width: 0, height: 155)
        )

        // Billing title
        billingText.anchor(
            top: circleView.topAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 12, left: 32, bottom: 0, right: 0)
        )

        // Labels (lado esquerdo)
        companyNameLabel.anchor(
            top: billingText.bottomAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 32, bottom: 0, right: 0)
        )

        periodLabel.anchor(
            top: companyNameLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 32, bottom: 0, right: 0)
        )

        totalGeneralLabel.anchor(
            top: periodLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 32, bottom: 0, right: 0)
        )

        numberOfClientsLabel.anchor(
            top: totalGeneralLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 32, bottom: 0, right: 0)
        )

        // Values (lado direito)
        companyNameLabelValue.anchor(
            top: companyNameLabel.topAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        )

        totalGeneralLabelValue.anchor(
            top: picker1.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 32)
        )

        numberOfAndTicketValue.anchor(
            top: numberOfClientsLabel.topAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        )

        // Pickers
        picker2.centerY(in: periodLabel)
        picker2.anchor(
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        )

        picker1.centerY(in: periodLabel)
        picker1.anchor(
            trailing: picker2.leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        )

        // Chart
        barChartView.anchor(
            leading: leadingAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 12),
            size: CGSize(width: 0, height: 320)
        )
    }
    
    func updateChart(data: [ResponseData]) {
        if shouldShowAxisInVertical  {
            barChartView.xAxis.labelRotationAngle = 90
        } else {
            barChartView.xAxis.labelRotationAngle = 0
        }
        responseValues = data
        calculateValue(data: data)
        setupBarChartData(data: data)
        self.numberOfClients = data.compactMap { $0.NumeroCliente }
        updateTotalAndTicketValue(data: data)
    }
    
    private func updateTotalAndTicketValue(data: [ResponseData]) {
        let totalClientsInPeriod = data.compactMap { $0.NumeroCliente }.reduce(0, +)
        if totalClientsInPeriod > 0 {
            let totalValue = data.reduce(0) { $0 + $1.Value }
            let ticketValue = totalValue / Double(totalClientsInPeriod)
            let formattedTicketValue = String(format: "%.2f", ticketValue).replacingOccurrences(of: ".", with: ",")
            numberOfAndTicketValue.text = "\(totalClientsInPeriod) / $\(formattedTicketValue)"
        } else {
            numberOfAndTicketValue.text = "N/A"
        }
    }
    
    @objc private func nameLabelTapped() {
        showCompanySelectionAlert()
    }
    
    private func showCompanySelectionAlert() {
        let alertController = UIAlertController(title: "Selecionar Empresa", message: "Escolha uma empresa:", preferredStyle: .actionSheet)

        if let presenter = delegate as? UIViewController {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = presenter.view
                popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }

        for profile in ProfileData.shared.profiles {
            let action = UIAlertAction(title: profile.Fantasia, style: .default) { [weak self] _ in
                self?.updateCompanyInfo(with: profile)
                self?.delegate?.getNewChart(startDate: self?.selectedStartDate, endDate: self?.selectedEndDate, code: profile.Codigo)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let presenter = delegate as? UIViewController {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }

    func updateCompanyInfo(with profile: ProfileResponseModel) {
        nameText.text = "\(profile.Fantasia) ▼ "
        self.code = profile.Codigo
        let cnpj = profile.CpfCnpj
        companyNameLabelValue.text = cnpj.formatCPFCNPJ(cnpj)
        UserDefaultsManager.shared.nome = profile.Fantasia
        UserDefaultsManager.shared.cpfCnpj = profile.CpfCnpj
        UserDefaultsManager.shared.telefone = profile.Telefone ?? ""
        UserDefaultsManager.shared.enderecoRua = profile.Endereco.Logradouro
        UserDefaultsManager.shared.enderecoNumero = profile.Endereco.Numero
        delegate?.getNewChart(startDate: self.selectedStartDate, endDate: self.selectedEndDate, code: self.code)
    }


}
