//
//  File.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 12/07/23.
//

import Foundation
import UIKit

class MainScreenView: UIView {
    public weak var delegate: MainScreenViewDelegate?
    // MARK: - variables
    // MARK: - setup
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error, not implemented")
    }
    // MARK: - private functions
    
    private func setupUI() {
        
        
        setupConstraints()
    }
    private func setupConstraints() {
        
        
    }
    
}
