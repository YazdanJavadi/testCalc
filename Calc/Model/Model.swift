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

class CalculatorModel {
    var firstNumber: String = "0"
    var secondNumber: String = ""
    var operation: CalcLogic? = nil
    var currentNumber: CurrentNumber = .firstNumber
    var isResultDisplayed: Bool = false

    func reset() {
        firstNumber = "0"
        secondNumber = ""
        operation = nil
        currentNumber = .firstNumber
        isResultDisplayed = false
    }

    func inputNumber(_ numberString: String) {
        if isResultDisplayed {
            reset()
        }

        if currentNumber == .firstNumber {
            if firstNumber == "0" {
                firstNumber = numberString
            } else {
                firstNumber += numberString
            }
        } else {
            secondNumber += numberString
        }
    }

    func inputDecimal() {
        if isResultDisplayed {
            reset()
        }

        if currentNumber == .firstNumber {
            if !firstNumber.contains(".") {
                firstNumber += "."
            }
        } else {
            if !secondNumber.contains(".") {
                secondNumber += "."
            }
        }
    }

    func inputOperation(_ operation: CalcLogic) {
        if self.operation != nil && currentNumber == .secondNumber && !secondNumber.isEmpty {
            if let _ = calculateResult() {
            }
        }
        self.operation = operation
        currentNumber = .secondNumber
    }

    func calculateResult() -> String? {
        guard let op = operation,
              let first = Double(firstNumber),
              let second = Double(secondNumber) else {
            return nil
        }

        let result = performOperation(op, first, second)
        reset()
        firstNumber = String(result)
        isResultDisplayed = true
        return firstNumber
    }

    private func performOperation(_ operation: CalcLogic, _ firstNumber: Double, _ secondNumber: Double) -> Double {
        switch operation {
        case .add:
            return firstNumber + secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .divide:
            return firstNumber / secondNumber
        }
    }

    func togglePlusMinus() {
        if currentNumber == .firstNumber {
            if firstNumber.starts(with: "-") {
                firstNumber.removeFirst()
            } else {
                firstNumber = "-" + firstNumber
            }
        } else {
            if secondNumber.starts(with: "-") {
                secondNumber.removeFirst()
            } else {
                secondNumber = "-" + secondNumber
            }
        }
    }

    func applyPercentage() {
        if currentNumber == .firstNumber {
            if let value = Double(firstNumber) {
                firstNumber = String(value / 100)
            }
        } else {
            if let value = Double(secondNumber) {
                secondNumber = String(value / 100)
            }
        }
    }

    func deleteLastInput() {
        if currentNumber == .firstNumber {
            if !firstNumber.isEmpty {
                firstNumber.removeLast()
                if firstNumber.isEmpty {
                    firstNumber = "0"
                }
            }
        } else {
            if !secondNumber.isEmpty {
                secondNumber.removeLast()
            }
        }
    }
}
