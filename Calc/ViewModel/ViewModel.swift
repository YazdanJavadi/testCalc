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
        if model.isResultDisplayed {
            didSelectAllClear()
        }
        model.inputNumber("\(number)")
        updateDisplay()
    }

    func didSelectOperation(_ operation: CalcLogic) {
        if model.isResultDisplayed {
            model.isResultDisplayed = false
        }
        model.inputOperation(operation)
        updateEquation()
        calcHeaderLabel = "0"
        updateViews?()
    }

    func didSelectEquals() {
        if let result = model.calculateResult() {
            calcHeaderLabel = formatResult(result)
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
        if model.isResultDisplayed {
            didSelectAllClear()
        }
        model.inputDecimal()
        updateDisplay()
    }

    func didSelectDelete() {
        if model.isResultDisplayed || calcHeaderLabel == "0" {
            didSelectAllClear()
        } else {
            model.deleteLastInput()
            updateDisplay()
        }
    }

    private func updateDisplay() {
        if model.currentNumber == .firstNumber {
            calcHeaderLabel = formatResult(model.firstNumber)
        } else {
            calcHeaderLabel = formatResult(model.secondNumber)
        }
        updateEquation()
        updateViews?()
    }

    private func updateEquation() {
        equation = formatResult(model.firstNumber)
        if let op = operationSymbol() {
            equation += " \(op)"
            if !model.secondNumber.isEmpty {
                equation += " \(formatResult(model.secondNumber))"
            }
        }
    }

    private func formatResult(_ numberString: String) -> String {
        guard let number = Double(numberString) else { return numberString }

        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return formatWithCommas(String(Int(number)))
        } else {
            return formatWithCommas(numberString)
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

    private func operationSymbol() -> String? {
        guard let op = model.operation else { return nil }
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
