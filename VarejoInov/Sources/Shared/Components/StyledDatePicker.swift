//
//  StyledDatePicker.swift
//  VarejoInov
//
//  Created by Samuel França on 24/10/25.
//

import UIKit

class StyledDatePicker: UIDatePicker {
    init(date: Date = Date(), width: CGFloat = 100, height: CGFloat = 28) {
        super.init(frame: .zero)

        setupDatePicker(date: date, width: width, height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDatePicker(date: Date, width: CGFloat, height: CGFloat) {
        datePickerMode = .date
        self.date = date
        tintColor = AppColors.primary
        layer.cornerRadius = 8
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setDate(_ date: Date) {
        setDate(date, animated: false)
    }
}
