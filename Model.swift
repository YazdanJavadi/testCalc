//
//  Model.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation

enum CalcLogic {
    case divide
    case multiply
    case subtract
    case add
     
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiply:
            return "×"
        case .subtract:
            return "-"
        case .add:
            return "+"
        }
    }
}
