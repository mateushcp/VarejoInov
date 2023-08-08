//
//  File.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit
import Charts

class MainScreenView: UIView {
    public weak var delegate: MainScreenViewDelegate?
    var responseValues: [ResponseData] = []
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    // MARK: - Variables
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1.0)
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
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let billingText: UILabel = {
        let label = UILabel()
        label.text = "Faturamento"
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Empresa: "
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "Periodo: "
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalGeneralLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Geral: "
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyNameLabelValue: UILabel = {
        let label = UILabel()
        label.text = "Inov"
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalGeneralLabelValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let picker1: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        datePicker.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let picker2: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.tintColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0)
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error, not implemented")
    }
    
    // MARK: - Private Functions
    
    private func calculateValue(data: [ResponseData]) {
        var totalValue: Double = 0
        
        for entry in data {
            totalValue += entry.value
        }
        let formattedTotalValue = String(format: "%.2f", totalValue)
        totalGeneralLabelValue.text = formattedTotalValue + " R$"
        
    }
    
    private func setupBarChartData(data: [ResponseData]) {
        var days: [String] = []
        var sales: [Double] = []
        
        for data in data {
            var dayLabel = data.label
            
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
            sales.append(data.value)
        }
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<days.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: sales[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [UIColor(red: 44/255, green: 143/255, blue: 174/255, alpha: 1.0)]
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
            delegate?.getNewChart(startDate: selectedStartDate, endDate: selectedEndDate)
            delegate?.setFilterDate(startDate: selectedStartDate, endDate: selectedEndDate)
        }
    }

    private func setupGestures() {
        picker1.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker2.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    private func setupUI(data: [ResponseData]) {
        addSubview(backgroundView)
        addSubview(barChartView)
        addSubview(circleView)
        addSubview(welcomeText)
        circleView.addSubview(billingText)
        circleView.addSubview(companyNameLabel)
        circleView.addSubview(periodLabel)
        circleView.addSubview(totalGeneralLabel)
        circleView.addSubview(companyNameLabelValue)
        circleView.addSubview(totalGeneralLabelValue)
        circleView.addSubview(welcomeText)
        addSubview(picker1)
        addSubview(picker2)

        
        setupBarChartData(data: data)
        setupConstraints()
        setupGestures()

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            welcomeText.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            welcomeText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            billingText.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 12),
            billingText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            
            companyNameLabel.topAnchor.constraint(equalTo: billingText.bottomAnchor, constant: 8),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            companyNameLabel.heightAnchor.constraint(equalTo: welcomeText.heightAnchor, multiplier: 0.5),
            
            periodLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 10),
            periodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            periodLabel.heightAnchor.constraint(equalTo: companyNameLabel.heightAnchor),
            
            totalGeneralLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 10),
            totalGeneralLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            totalGeneralLabel.heightAnchor.constraint(equalTo: companyNameLabel.heightAnchor),
            
            companyNameLabelValue.topAnchor.constraint(equalTo: companyNameLabel.topAnchor),
            companyNameLabelValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            companyNameLabelValue.heightAnchor.constraint(equalTo: welcomeText.heightAnchor, multiplier: 0.5),
  
            totalGeneralLabelValue.topAnchor.constraint(equalTo: picker1.bottomAnchor, constant: 10),
            totalGeneralLabelValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            totalGeneralLabelValue.heightAnchor.constraint(equalTo: companyNameLabelValue.heightAnchor),
            
            barChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            barChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            barChartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            barChartView.heightAnchor.constraint(equalToConstant: 360),
            
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            circleView.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 16),
            circleView.heightAnchor.constraint(equalToConstant: 130),
            
            picker1.centerYAnchor.constraint(equalTo: periodLabel.centerYAnchor),
            picker1.trailingAnchor.constraint(equalTo: picker2.leadingAnchor, constant: -8),
            picker1.widthAnchor.constraint(equalToConstant: 100),
            picker1.heightAnchor.constraint(equalToConstant: 28),
            
            picker2.centerYAnchor.constraint(equalTo: periodLabel.centerYAnchor),
            picker2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            picker2.widthAnchor.constraint(equalToConstant: 100),
            picker2.heightAnchor.constraint(equalToConstant: 28)

        ])
    }
    
    func updateChart(data: [ResponseData]) {
        responseValues = data
        calculateValue(data: data)
        setupBarChartData(data: data)
    }
}
