//
//  Utility_Extension.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/20.
//  Copyright © 2017年 william. All rights reserved.
//

import Foundation

extension String {
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

extension Date {
    func addYear(add: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: add, to: self)!
    }
    
    func addMonth(add: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: add, to: self)!
    }
    
    func addDay(add: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: add, to: self)!
    }
    func create(year: Int, month: Int, day: Int) -> Date {
        var dateComponets = DateComponents()
        dateComponets.year = year
        dateComponets.month = month
        dateComponets.day = day
        
        return Calendar(identifier: .gregorian).date(from: dateComponets)!
    }
    
}
