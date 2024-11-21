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

    var previousFirstNumber: String?
    var previousSecondNumber: String?
    var previousOperation: CalcLogic?

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
            firstNumber = numberString
            return
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
            firstNumber = "0."
            return
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
        var op: CalcLogic
        var firstNumStr: String
        var secondNumStr: String

        if let currentOp = operation, !secondNumber.isEmpty {
            op = currentOp
            firstNumStr = firstNumber
            secondNumStr = secondNumber
            previousFirstNumber = firstNumber
            previousSecondNumber = secondNumber
            previousOperation = operation
        } else if let prevOp = previousOperation, let prevSecond = previousSecondNumber {
            op = prevOp
            firstNumStr = firstNumber
            secondNumStr = prevSecond
        } else {
            return firstNumber
        }

        guard let first = Double(firstNumStr), let second = Double(secondNumStr) else {
            return "Error"
        }

        let result = performOperation(op, first, second)

        if result.isNaN || result.isInfinite {
            isResultDisplayed = true
            return "Error"
        }

        firstNumber = String(result)
        secondNumber = ""
        operation = nil
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
            if secondNumber == 0 {
                return Double.nan
            }
            return firstNumber / secondNumber
        }
    }

    func togglePlusMinus() {
        if currentNumber == .firstNumber {
            if firstNumber.starts(with: "-") {
                firstNumber.removeFirst()
            } else if firstNumber != "0" {
                firstNumber = "-" + firstNumber
            }
        } else {
            if secondNumber.starts(with: "-") {
                secondNumber.removeFirst()
            } else if secondNumber != "" {
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
            if !firstNumber.isEmpty && firstNumber != "0" {
                firstNumber.removeLast()
                if firstNumber.isEmpty || firstNumber == "-" || firstNumber == "-0" {
                    firstNumber = "0"
                }
            }
        } else {
            if !secondNumber.isEmpty {
                secondNumber.removeLast()
                if secondNumber.isEmpty || secondNumber == "-" || secondNumber == "-0" {
                    secondNumber = ""
                }
            }
        }
    }
}
