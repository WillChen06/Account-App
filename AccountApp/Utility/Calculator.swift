//
//  Calculator.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/01/15.
//  Copyright © 2018年 william. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Properties
    fileprivate var period = "."
    fileprivate var display: String
    fileprivate var leftOperand: Double?
    fileprivate var operatorValue: String?
    fileprivate var isLastCharacterOperator = false
    fileprivate var isFirstValue = true
    
     /// - returns: The display value of the calculator.
    public var displayValue: String {
        get {
            return !(display.isEmpty) ? display : "0"
        }
        set {
            return display = newValue
        }
    }
    
    // MARK: - Init
    public init() {
        self.display = String()
        self.operatorValue = nil
    }
    
    // MARK: - Calculator Operation
    
    public func input(_ input: String?) throws {
        guard display.count < 10 || (input?.isClear)! else {
            throw CalculatorError.overInput
        }
        
        guard let input = input else {
            throw CalculatorError.nilInput
        }
        
        guard input.isValidCharacter else {
            throw CalculatorError.invalidCharater
        }
 
        // FIXME: Fix input zero bug
        if input.isValidDigit || input.isDoubleZero {
            if isLastCharacterOperator && (input == "0" || input == "00") { return }
            if isLastCharacterOperator {
                display = input
                isLastCharacterOperator = false
            }
            else if !input.isPeriod || !(display.contains(period)) {
                // Add it to the current display.
                display += input
            }
        } else if input.isOperator || input.isEqualSign {
            NotificationCenter.default.post(name: .changeToEqual, object: nil)
            if (operatorValue == nil) && !(input.isEqualSign){
                leftOperand = Double(displayValue)
                operatorValue = input
            } else {
                if let sign = operatorValue, let operand = leftOperand, let rightOperand = Double(displayValue) {
                    
                    if let result = operation(left: operand, right: rightOperand, sign: sign) {
                        display = "\(String(format: "%g", result))"
                    }
                }
                operatorValue = (input.isEqualSign) ? nil : input
            }
            
            isLastCharacterOperator = true
        } else if input.isOkSign{
            NotificationCenter.default.post(name: .hideCalculator, object: nil)
        } else if input.isClear {
            if !(display.isEmpty) {
                display.removeAll()
            } else {
                operatorValue = nil
            }
        } else if input.isDelete {
            if display.isEmpty {
                display = String(display.dropLast())
            }
            isLastCharacterOperator = false
        }
    }
    
    fileprivate func operation (left: Double, right: Double, sign: String) -> Double? {
        switch sign {
        case "+": return left + right
        case "-": return left - right
        case "x": return left * right
        case "/": return left / right
        default: break
        }
        return nil
    }
}

enum CalculatorError: Error {
    case invalidCharater
    case multipleCharacters
    case nilInput
    case overInput
}

extension CalculatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCharater: return NSLocalizedString("Invalid character exception.", comment: "The input is not a number between 0-9, an operator (+, -, *, /), D, C, =, or a period.")
        case .multipleCharacters: return NSLocalizedString("Multiple characters exception.", comment: "The input contains more than one character.")
        case .nilInput: return NSLocalizedString("Nil exception.", comment: "The input is nil.")
        case .overInput: return NSLocalizedString("Over Input", comment: "The max input is ten characters.")
        }
    }
}
