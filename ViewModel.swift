//
//  ViewModel.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation

class CalcControllerViewModel {

    var updateViews: (() -> Void)?
    var model = CalculatorModel()
    var equation: String = ""
    var calcHeaderLabel: String = "0"

    let calcButtonCells: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equal
    ]

    func didSelectAllClear() {
        model.reset()
        calcHeaderLabel = "0"
        equation = ""
        updateViews?()
    }

    func didSelectNumber(_ number: Int) {
        model.inputNumber("\(number)")
        updateDisplay()
    }

    func didSelectOperation(_ operation: CalcLogic) {
        if model.isResultDisplayed {
            model.isResultDisplayed = false
        }
        model.inputOperation(operation)
        updateEquation()
        // Remove resetting calcHeaderLabel to "0"
        updateViews?()
    }

    func didSelectEquals() {
        if let result = model.calculateResult() {
            let firstNum = model.previousFirstNumber ?? model.firstNumber
            let secondNum = model.previousSecondNumber ?? model.secondNumber
            let opSymbol = operationSymbol(for: model.previousOperation ?? model.operation) ?? ""
            let equationString = "\(formatResult(firstNum)) \(opSymbol) \(formatResult(secondNum))"
            equation = equationString
            calcHeaderLabel = formatResult(result)
            updateViews?()
        } else {
            calcHeaderLabel = formatResult(model.firstNumber)
            equation = ""
            updateViews?()
        }
    }

    func didSelectPlusMinus() {
        model.togglePlusMinus()
        updateDisplay()
    }

    func didSelectPercentage() {
        model.applyPercentage()
        updateDisplay()
    }

    func didSelectDecimal() {
        model.inputDecimal()
        updateDisplay()
    }

    func didSelectDelete() {
        if model.isResultDisplayed {
            model.isResultDisplayed = false
            model.currentNumber = .firstNumber
            model.secondNumber = ""
        }
        model.deleteLastInput()
        updateDisplay()
    }

    private func updateDisplay() {
        if model.currentNumber == .firstNumber {
            calcHeaderLabel = formatResult(model.firstNumber)
        } else {
            if model.secondNumber.isEmpty {
                calcHeaderLabel = formatResult(model.firstNumber)
            } else {
                calcHeaderLabel = formatResult(model.secondNumber)
            }
        }
        updateEquation()
        updateViews?()
    }

    private func updateEquation() {
        equation = formatResult(model.firstNumber)
        if let op = operationSymbol(for: model.operation) {
            equation += " \(op)"
            if !model.secondNumber.isEmpty {
                equation += " \(formatResult(model.secondNumber))"
            }
        }
    }

    private func formatResult(_ numberString: String) -> String {
        if numberString == "Error" {
            return "Error"
        }

        if numberString.hasSuffix(".") {
            return formatWithCommas(numberString)
        }

        guard let number = Double(numberString) else { return numberString }

        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return formatWithCommas(String(Int(number)))
        } else {
            return formatWithCommas(numberString)
        }
    }

    private func formatWithCommas(_ numberString: String) -> String {
        if numberString.isEmpty || numberString == "-" {
            return numberString
        }

        let startsWithDecimal = numberString.hasPrefix(".")
        let endsWithDecimal = numberString.hasSuffix(".")

        let isNegative = numberString.hasPrefix("-")
        let positiveNumberString = isNegative ? String(numberString.dropFirst()) : numberString

        var integerPart: String
        var fractionalPart: String = ""

        if startsWithDecimal {
            integerPart = "0"
            fractionalPart = positiveNumberString
        } else {
            let components = positiveNumberString.split(separator: ".")
            integerPart = String(components[0])

            if components.count > 1 {
                fractionalPart = "." + components[1]
            } else if endsWithDecimal {
                fractionalPart = "."
            }
        }

        if integerPart.count >= 4 {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = ","
            numberFormatter.maximumFractionDigits = 10
            numberFormatter.usesGroupingSeparator = true

            if let intNumber = Int(integerPart) {
                let formattedIntegerPart = numberFormatter.string(from: NSNumber(value: intNumber)) ?? integerPart
                let formattedNumber = formattedIntegerPart + fractionalPart
                return isNegative ? "-" + formattedNumber : formattedNumber
            } else {
                let formattedNumber = integerPart + fractionalPart
                return isNegative ? "-" + formattedNumber : formattedNumber
            }
        } else {
            let formattedNumber = integerPart + fractionalPart
            return isNegative ? "-" + formattedNumber : formattedNumber
        }
    }

    private func operationSymbol(for op: CalcLogic?) -> String? {
        guard let op = op else { return nil }
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
            didSelectAllClear()
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
