//
//  Buttons.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation
import UIKit

final class Views: UICollectionViewCell {
    static let identifier = "Views"
    
    private(set) var calcButton: Buttons!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    public func configure(with calcButton: Buttons) {
        self.calcButton = calcButton
        
        // Set title and background color based on button type
        titleLabel.text = calcButton.title
        backgroundColor = calcButton.color
        
        // Set text color manually for each case
        switch calcButton {
        case .allClear, .plusMinus, .percentage:
            titleLabel.textColor = .black
        default:
            titleLabel.textColor = .white
        }
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set corner radius based on button type
        if case .number(0) = calcButton {
            layer.cornerRadius = 36
            let spacing = frame.width - frame.height
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: frame.height),
                titleLabel.widthAnchor.constraint(equalToConstant: frame.height),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing)
            ])
        } else {
            layer.cornerRadius = frame.size.width / 2
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.heightAnchor.constraint(equalTo: heightAnchor),
                titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.removeFromSuperview()
    }
}

enum Buttons {
    case allClear, plusMinus, percentage, divide, multiply, subtract, add, equal, decimal
    case number(Int)
    
    var title: String {
        switch self {
        case .allClear: return "AC"
        case .plusMinus: return "+/-"
        case .percentage: return "%"
        case .divide: return "÷"
        case .multiply: return "×"
        case .subtract: return "-"
        case .add: return "+"
        case .equal: return "="
        case .number(let value): return "\(value)"
        case .decimal: return "."
        }
    }
    
    var color: UIColor {
        switch self {
        case .allClear, .plusMinus, .percentage:
            return .lightGray
        case .divide, .multiply, .subtract, .add, .equal:
            return .systemOrange
        case .number, .decimal:
            return .darkGray
        }
    }
}
