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
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 72, weight: .regular)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(currenctNumber: String) {
        self.label.text = currenctNumber
    }
    
    private func setupViews() {
        self.backgroundColor = .black
        self.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
