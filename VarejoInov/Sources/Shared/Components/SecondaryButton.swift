//
//  SecondaryButton.swift
//  VarejoInov
//
//  Created by Samuel França on 24/10/25.
//

import UIKit

class SecondaryButton: UIButton {
    init(title: String, height: CGFloat = 50, width: CGFloat? = nil) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setupButton(height: height, width: width)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(height: CGFloat, width: CGFloat?) {
        setTitleColor(AppColors.primary, for: .normal)
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: height).isActive = true

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        layer.cornerRadius = 16
        layer.borderColor = AppColors.primary.cgColor
        layer.borderWidth = 2

        translatesAutoresizingMaskIntoConstraints = false
    }
}
