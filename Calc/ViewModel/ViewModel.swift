//
//  ViewModel.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import Foundation

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CalcControllerViewModel {
    
    var updateViews: (() -> Void)?
    private var lastOperation: CalcLogic?
    private var lastSecondNumber: Int?
    let calcButtonCells: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equal
    ]
    
    
    lazy var firstNumber: Int? = nil
    lazy var secondNumber: Int? = nil
    lazy var operation: CalcLogic? = nil
    lazy var currentNumber: CurrentNumber = .firstNumber
    
    var calcHeaderLabel: String = "0"
    
    func didSelectAllClear() {
        firstNumber = nil
        secondNumber = nil
        operation = nil
        currentNumber = .firstNumber
        calcHeaderLabel = "0"
        updateViews?()
    }
    
    func didSelectNumber(_ number: Int) {
        if currentNumber == .firstNumber {
            if let first = firstNumber {
                firstNumber = first * 10 + number
            } else {
                firstNumber = number
            }
            calcHeaderLabel = firstNumber?.description ?? "0"
        } else {
            if let second = secondNumber {
                secondNumber = second * 10 + number
            } else {
                secondNumber = number
            }
            calcHeaderLabel = secondNumber?.description ?? "0"
        }
        updateViews?()
    }
    
    func didSelectOperation(_ operation: CalcLogic) {
        self.operation = operation
        currentNumber = .secondNumber
        updateViews?()
    }
    
    func didSelectEquals() {
        if let operation = operation, let firstNumber = firstNumber, let secondNumber = secondNumber {
            let result = performOperation(operation, firstNumber, secondNumber)
            
            self.lastOperation = operation
            self.lastSecondNumber = secondNumber
            self.firstNumber = result
            self.secondNumber = nil
            self.operation = nil
            calcHeaderLabel = "\(result)"
        }
        else if let lastOperation = lastOperation, let lastSecondNumber = lastSecondNumber, let firstNumber = firstNumber {
            let result = performOperation(lastOperation, firstNumber, lastSecondNumber)
            self.firstNumber = result
            calcHeaderLabel = "\(result)"
        }
        
        updateViews?()
    }
    
    private func performOperation(_ operation: CalcLogic, _ firstNumber: Int, _ secondNumber: Int) -> Int {
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
    
    func didSelectPlusMinus() {
        if currentNumber == .firstNumber, let first = firstNumber {
            firstNumber = -first
            calcHeaderLabel = "\(firstNumber!)"
        } else if currentNumber == .secondNumber, let second = secondNumber {
            secondNumber = -second
            calcHeaderLabel = "\(secondNumber!)"
        }
        updateViews?()
    }
    
    func didSelectPercentage() {
        if currentNumber == .firstNumber, let first = firstNumber {
            firstNumber = first / 100
            calcHeaderLabel = "\(firstNumber!)"
        } else if currentNumber == .secondNumber, let second = secondNumber, let first = firstNumber, let operation = operation {
            switch operation {
            case .add, .subtract:
                secondNumber = first * (second / 100)
            case .multiply, .divide:
                secondNumber = second / 100
            }
            calcHeaderLabel = "\(secondNumber!)"
        }
        updateViews?()
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
            
            break
        }
    }
}
