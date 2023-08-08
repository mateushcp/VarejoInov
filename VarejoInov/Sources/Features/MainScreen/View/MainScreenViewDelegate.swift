//
//  MainScreenViewDelegate.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation

protocol MainScreenViewDelegate: AnyObject {
    func getNewChart(startDate: Date?, endDate: Date?)
    func setFilterDate(startDate: Date?, endDate: Date?)
}
