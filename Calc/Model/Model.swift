//
//  Model.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation
import UIKit

enum CalcLogic {
    case add, subtract, multiply, divide
}

enum CurrentNumber {
    case firstNumber, secondNumber
}

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
