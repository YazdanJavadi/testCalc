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
    
    public func configure(with calcButton: Buttons, shouldShowDelete: Bool = false) {
        self.calcButton = calcButton
        
        // Set title and background color based on button type
        titleLabel.text = shouldShowDelete && calcButton == .allClear ? Buttons.delete.title : calcButton.title
        backgroundColor = calcButton.color
        
        // Set text color based on button type
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
    
    override var isHighlighted: Bool {
        didSet {
            // Change background color on press
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
