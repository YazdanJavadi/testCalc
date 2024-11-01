//
//  ViewModel.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation

class CalcControllerViewModel {
    
    var updateViews: (() -> Void)?
    var isResultDisplayed: Bool = false
    var equation: String = ""
    var calcHeaderLabel: String = "0"
    
    let calcButtonCells: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equal
    ]
    
    var firstNumber: Double? = nil
    var secondNumber: Double? = nil
    var operation: CalcLogic? = nil
    var currentNumber: CurrentNumber = .firstNumber
    var isDecimalActive: Bool = false
    
    func didSelectAllClear() {
        equation = ""
        firstNumber = nil
        secondNumber = nil
        operation = nil
        currentNumber = .firstNumber
        isDecimalActive = false
        calcHeaderLabel = "0"
        isResultDisplayed = false
        updateViews?()
    }
    
    func didSelectNumber(_ number: Int) {
        if isResultDisplayed {
            didSelectAllClear()
        }
        
        if calcHeaderLabel == "0" && !isDecimalActive {
            calcHeaderLabel = "\(number)"
        } else {
            calcHeaderLabel += "\(number)"
        }
        
        let rawNumberString = calcHeaderLabel.replacingOccurrences(of: ",", with: "")
        
        if currentNumber == .firstNumber {
            firstNumber = Double(rawNumberString)
        } else {
            secondNumber = Double(rawNumberString)
        }
        
        calcHeaderLabel = formatWithCommas(rawNumberString)
        
        if currentNumber == .firstNumber {
            equation = calcHeaderLabel
        } else if currentNumber == .secondNumber, let op = operationSymbol() {
            equation = "\(formatNumberForEquation(firstNumber)) \(op) \(calcHeaderLabel)"
        }
        
        isResultDisplayed = false
        updateViews?()
    }
    
    func didSelectOperation(_ operation: CalcLogic) {
        if isResultDisplayed {
            isResultDisplayed = false
        }
        
        if self.operation != nil && currentNumber == .secondNumber {
            didSelectEquals()
            firstNumber = Double(calcHeaderLabel.replacingOccurrences(of: ",", with: "")) ?? 0
        } else {
            if firstNumber == nil {
                firstNumber = Double(calcHeaderLabel.replacingOccurrences(of: ",", with: "")) ?? 0
            }
        }
        
        self.operation = operation
        currentNumber = .secondNumber
        isDecimalActive = false
        
        equation = "\(formatNumberForEquation(firstNumber)) \(operationSymbol() ?? "")"
        
        calcHeaderLabel = "0"
        
        updateViews?()
    }
    
    func didSelectEquals() {
        guard let operation = operation else { return }
        guard let firstValue = firstNumber else { return }
        guard let secondValue = secondNumber else { return }
        
        let result = performOperation(operation, firstValue, secondValue)
        calcHeaderLabel = formatResult(result)
        
        equation = "\(formatNumberForEquation(firstValue)) \(operationSymbol() ?? "") \(formatNumberForEquation(secondValue)) ="
        
        firstNumber = result
        secondNumber = nil
        self.operation = nil
        currentNumber = .firstNumber
        isDecimalActive = false
        isResultDisplayed = true
        
        updateViews?()
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
    
    private func formatWithCommas(_ numberString: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.maximumFractionDigits = 10
        
        if let number = Double(numberString) {
            return numberFormatter.string(from: NSNumber(value: number)) ?? numberString
        }
        
        return numberString
    }
    
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return formatWithCommas(String(Int(result)))
        } else {
            return formatWithCommas(String(result))
        }
    }
    
    func didSelectPlusMinus() {
        if currentNumber == .firstNumber {
            if let first = firstNumber {
                firstNumber = -first
                calcHeaderLabel = formatResult(firstNumber!)
            }
        } else {
            if let second = secondNumber {
                secondNumber = -second
                calcHeaderLabel = formatResult(secondNumber!)
            }
        }
        
        // Update the equation label
        if currentNumber == .firstNumber {
            equation = calcHeaderLabel
        } else if currentNumber == .secondNumber, let op = operationSymbol() {
            equation = "\(formatNumberForEquation(firstNumber)) \(op) \(calcHeaderLabel)"
        }
        
        isResultDisplayed = false
        updateViews?()
    }
    
    func didSelectPercentage() {
        if currentNumber == .firstNumber {
            if let first = firstNumber {
                firstNumber = first / 100
                calcHeaderLabel = formatResult(firstNumber!)
            }
        } else {
            if let second = secondNumber {
                secondNumber = second / 100
                calcHeaderLabel = formatResult(secondNumber!)
            }
        }
        
        if currentNumber == .firstNumber {
            equation = calcHeaderLabel
        } else if currentNumber == .secondNumber, let op = operationSymbol() {
            equation = "\(formatNumberForEquation(firstNumber)) \(op) \(calcHeaderLabel)"
        }
        
        isResultDisplayed = false
        updateViews?()
    }
    
    func didSelectDecimal() {
        guard !isDecimalActive else { return }
        isDecimalActive = true
        
        if !calcHeaderLabel.contains(".") {
            calcHeaderLabel += "."
            updateViews?()
        }
    }
    
    func didSelectDelete() {
        if isResultDisplayed || calcHeaderLabel == "0" {
            didSelectAllClear()
        } else {
            calcHeaderLabel.removeLast()
            
            if calcHeaderLabel.isEmpty || calcHeaderLabel == "-" || calcHeaderLabel == "." {
                calcHeaderLabel = "0"
                if currentNumber == .firstNumber {
                    firstNumber = nil
                } else {
                    secondNumber = nil
                }
            } else {
                let rawNumberString = calcHeaderLabel.replacingOccurrences(of: ",", with: "")
                if currentNumber == .firstNumber {
                    firstNumber = Double(rawNumberString)
                } else {
                    secondNumber = Double(rawNumberString)
                }
            }
            
            if currentNumber == .firstNumber {
                equation = calcHeaderLabel
            } else if currentNumber == .secondNumber, let op = operationSymbol() {
                equation = "\(formatNumberForEquation(firstNumber)) \(op) \(calcHeaderLabel)"
            }
            
            updateViews?()
        }
    }
    
    private func formatNumberForEquation(_ number: Double?) -> String {
        guard let num = number else { return "0" }
        return formatResult(num)
    }
    
    private func operationSymbol() -> String? {
        guard let op = operation else { return nil }
        switch op {
        case .add:
            return "+"
        case .subtract:
            return "−"
        case .multiply:
            return "×"
        case .divide:
            return "÷"
        }
    }
    
    func didSelectButton(with calcButton: Buttons) {
        switch calcButton {
        case .allClear:
            didSelectDelete()
        case .plusMinus:
            didSelectPlusMinus()
        case .percentage:
            didSelectPercentage()
        case .divide:
            didSelectOperation(.divide)
        case .multiply:
            didSelectOperation(.multiply)
        case .subtract:
            didSelectOperation(.subtract)
        case .add:
            didSelectOperation(.add)
        case .equal:
            didSelectEquals()
        case .number(let number):
            didSelectNumber(number)
        case .decimal:
            didSelectDecimal()
        case .delete:
            didSelectDelete()
        }
    }
}
