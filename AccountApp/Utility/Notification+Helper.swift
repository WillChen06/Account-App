//
//  Notification+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/01.
//  Copyright © 2018年 william. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let saveExpenses = Notification.Name("saveExpenses")
    static let clearExpenses = Notification.Name("clearExpenses")
    static let saveIncome = Notification.Name("saveIncome")
    static let clearIncome = Notification.Name("clearIncome")
    static let dismissVC = Notification.Name("dismissVC")
    static let changeToEqual = Notification.Name("changeToEqual")
    static let hideCalculator = Notification.Name("hideCalculator")
}
