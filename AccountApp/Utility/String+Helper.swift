//
//  String+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/15.
//  Copyright © 2018年 william. All rights reserved.
//

import Foundation

extension String {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    // MARK: - Calculator Input String
    
    /// Determines whether the string is the Delete charater.
    var isDelete: Bool {
        return (self == "D")
    }
    
    /// Determines whether the string is a period.
    var isPeriod: Bool {
        return (self == ".")
    }
    
    /// Determines whether the string is the Clear charater.
    var isClear: Bool {
        return (self == "C")
    }
    
    /// Determines whether the string is a period or a number between 0 and 9.
    var isValidDigit: Bool {
        let digits = "0123456789."
        return digits.contains(self)
    }
    
    var isDoubleZero: Bool {
        return (self == "00")
    }
    
    /// Determines whether the string is an operator such as +, -, *, or /.
    var isOperator: Bool {
        let operators = "+-x/"
        return operators.contains(self)
    }
    
    /// Determines whether the string is an equal sign.
    var isEqualSign: Bool {
        return (self == "=")
    }
    
    var isOkSign: Bool {
        return (self == "OK")
    }
    
    /// Determines whether a string is a valid character such as a digit, a.
    var isValidCharacter: Bool {
        return ( isValidDigit || isDoubleZero || isOperator || isDelete || isClear || isPeriod || isEqualSign || isOkSign)
    }
}
