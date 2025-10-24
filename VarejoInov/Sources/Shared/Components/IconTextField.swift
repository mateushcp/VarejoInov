//
//  IconTextField.swift
//  VarejoInov
//
//  Created by Samuel França on 24/10/25.
//

import UIKit

class IconTextField: UITextField {
    private var eyeButton: UIButton?

    init(placeholder: String, leftIcon: UIImage?, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)

        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.keyboardType = keyboardType

        setupTextField()
        setupLeftIcon(leftIcon)

        if isSecure {
            setupPasswordToggle()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField() {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        layer.cornerRadius = 16
        textAlignment = .left
        backgroundColor = .white
        textColor = AppColors.textPrimary
        tintColor = AppColors.textPrimary
        translatesAutoresizingMaskIntoConstraints = false

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColors.textSecondary
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
    }

    private func setupLeftIcon(_ icon: UIImage?) {
        guard let icon = icon else { return }

        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = AppColors.primary
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 8, y: 0, width: 24, height: 56)
        iconContainerView.addSubview(iconImageView)

        leftView = iconContainerView
        leftViewMode = .always
    }

    private func setupPasswordToggle() {
        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 56))

        eyeButton = UIButton(type: .custom)
        eyeButton?.setImage(UIImage(named: "eyeClosedIcon"), for: .normal)
        eyeButton?.setImage(UIImage(named: "eyeOpenIcon"), for: .selected)
        eyeButton?.tintColor = AppColors.primary
        eyeButton?.frame = CGRect(x: -8, y: 16, width: 24, height: 24)
        eyeButton?.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        if let button = eyeButton {
            rightContainerView.addSubview(button)
        }

        rightView = rightContainerView
        rightViewMode = .always
    }

    @objc private func togglePasswordVisibility() {
        eyeButton?.isSelected.toggle()
        isSecureTextEntry.toggle()
    }
}
