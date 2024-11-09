//
//  Buttons.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation
import UIKit

import UIKit

enum Buttons: Equatable {
    case allClear, plusMinus, percentage, divide, multiply, subtract, add, equal, decimal, delete
    case number(Int)

    var title: String {
        switch self {
        case .allClear: return "AC"
        case .delete: return "Del"
        case .plusMinus: return "+/-"
        case .percentage: return "%"
        case .divide: return "÷"
        case .multiply: return "×"
        case .subtract: return "−"
        case .add: return "+"
        case .equal: return "="
        case .number(let value): return "\(value)"
        case .decimal: return "."
        }
    }

    var color: UIColor {
        switch self {
        case .allClear, .delete, .plusMinus, .percentage:
            return .lightGray
        case .divide, .multiply, .subtract, .add, .equal:
            return .systemOrange
        case .number, .decimal:
            return .darkGray
        }
    }
}


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
    
    public func configure(with calcButton: Buttons, shouldShowDelete: Bool = false) {
        self.calcButton = calcButton
        
        titleLabel.text = shouldShowDelete && calcButton == .allClear ? Buttons.delete.title : calcButton.title
        backgroundColor = calcButton.color
        
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
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : calcButton.color
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.removeFromSuperview()
        backgroundColor = calcButton.color
    }
    
    public func updateButtonTitleForClear(hasContent: Bool) {
        if calcButton == .allClear {
            titleLabel.text = hasContent ? Buttons.delete.title : Buttons.allClear.title
        }
    }
}
