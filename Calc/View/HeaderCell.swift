//
//  HeaderCell.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation
import UIKit

final class HeaderCell: UICollectionViewCell {
    static let identifier = "HeaderCell"
    
    private let equationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.isHidden = true // Hidden initially
        return label
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right // Right alignment for right-to-left writing
        label.font = .systemFont(ofSize: 72, weight: .regular)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true // Enable automatic font size adjustment
        label.minimumScaleFactor = 0.3 // Adjust as needed
        label.lineBreakMode = .byTruncatingHead // Truncate the beginning if needed
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(currentNumber: String, equation: String?) {
        self.label.text = currentNumber
        
        if let equation = equation, !equation.isEmpty {
            equationLabel.text = equation
            equationLabel.isHidden = false
        } else {
            equationLabel.text = nil
            equationLabel.isHidden = true
        }
    }

    private func setupViews() {
        self.backgroundColor = .black
        
        // Add equation label and main label
        self.addSubview(equationLabel)
        self.addSubview(label)
        
        equationLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Equation label constraints
            equationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            equationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            equationLabel.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -8),
            
            // Main label constraints
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            label.topAnchor.constraint(greaterThanOrEqualTo: equationLabel.bottomAnchor, constant: 8)
        ])
    }
}
