//
//  PrimaryButton.swift
//  VarejoInov
//
//  Created by Samuel França on 24/10/25.
//

import UIKit

class PrimaryButton: UIButton {
    private var isButtonEnabled: Bool = true {
        didSet {
            updateAppearance()
        }
    }

    init(title: String, height: CGFloat = 56) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setupButton(height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(height: CGFloat) {
        backgroundColor = AppColors.primary
        setTitleColor(AppColors.textOnPrimary, for: .normal)
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func updateAppearance() {
        isEnabled = isButtonEnabled
        backgroundColor = isButtonEnabled ? AppColors.primary : AppColors.disabled
    }

    func setEnabled(_ enabled: Bool) {
        isButtonEnabled = enabled
    }
}
