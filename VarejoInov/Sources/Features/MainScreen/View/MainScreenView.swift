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
    
    // MARK: - Variables
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(red: 18/255, green: 0/255, blue: 82/255, alpha: 1.0).cgColor
        view.layer.borderWidth = 2
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
    
    private let billingText: UILabel = {
        let label = UILabel()
        label.text = "Faturamento"
        label.textColor = UIColor(red: 44/255, green: 143/255, blue: 174/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
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
    
    private let periodLabelValue: UILabel = {
        let label = UILabel()
        label.text = "Ultimos 3 dias"
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
        chartView.xAxis.labelRotationAngle = -90
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
    
    func setupBarChartData(data: [ResponseData]) {
        var days: [String] = []
        var sales: [Double] = []
        
        for data in data {
            days.append(data.label)
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
    
    private func setupUI(data: [ResponseData]) {
        addSubview(backgroundView)
        addSubview(billingText)
        addSubview(companyNameLabel)
        addSubview(periodLabel)
        addSubview(totalGeneralLabel)
        addSubview(companyNameLabelValue)
        addSubview(periodLabelValue)
        addSubview(totalGeneralLabelValue)
        addSubview(barChartView)
        addSubview(circleView)
        
        setupBarChartData(data: data)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            billingText.topAnchor.constraint(equalTo: topAnchor, constant: 42),
            billingText.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            companyNameLabel.topAnchor.constraint(equalTo: billingText.bottomAnchor, constant: 32),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            companyNameLabel.heightAnchor.constraint(equalTo: billingText.heightAnchor, multiplier: 0.5),
            
            periodLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 10),
            periodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            periodLabel.heightAnchor.constraint(equalTo: companyNameLabel.heightAnchor),
            
            totalGeneralLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 10),
            totalGeneralLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            totalGeneralLabel.heightAnchor.constraint(equalTo: companyNameLabel.heightAnchor),
            
            companyNameLabelValue.topAnchor.constraint(equalTo: billingText.bottomAnchor, constant: 32),
            companyNameLabelValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            companyNameLabelValue.heightAnchor.constraint(equalTo: billingText.heightAnchor, multiplier: 0.5),
            
            periodLabelValue.topAnchor.constraint(equalTo: companyNameLabelValue.bottomAnchor, constant: 10),
            periodLabelValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            periodLabelValue.heightAnchor.constraint(equalTo: companyNameLabelValue.heightAnchor),
            
            totalGeneralLabelValue.topAnchor.constraint(equalTo: periodLabelValue.bottomAnchor, constant: 10),
            totalGeneralLabelValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            totalGeneralLabelValue.heightAnchor.constraint(equalTo: companyNameLabelValue.heightAnchor),
            
            barChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            barChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            barChartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            barChartView.heightAnchor.constraint(equalToConstant: 360),
            
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            circleView.bottomAnchor.constraint(equalTo: totalGeneralLabel.bottomAnchor, constant: 8),
            circleView.heightAnchor.constraint(equalTo: billingText.heightAnchor, constant: 60)
        ])
    }
}
