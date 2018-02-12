//
//  StringLocalizable.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/17.
//  Copyright © 2017年 william. All rights reserved.
//

import Foundation

// MARK: - Universal
extension String {
    static let setting = NSLocalizedString("Setting", comment: "")
    static let save = NSLocalizedString("Save", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
    static let today = NSLocalizedString("Today", comment: "")
    static let pleaseEnter = NSLocalizedString("PleaseEnter", comment: "")
    static let pleaseChoose = NSLocalizedString("PleaseChoose", comment: "")
    static let done = NSLocalizedString("Done", comment: "")
    static let ok = NSLocalizedString("Ok", comment: "")
    static let other = NSLocalizedString("Other", comment: "")
}

// MARK: - Account
extension String {
    static let income = NSLocalizedString("Income", comment: "")
    static let expenses = NSLocalizedString("Expenses", comment: "")
    static let amount = NSLocalizedString("Amount", comment: "")
    static let category = NSLocalizedString("Category", comment: "")
    static let account = NSLocalizedString("Account", comment: "")
    static let cash = NSLocalizedString("Cash", comment: "")
    static let bank = NSLocalizedString("Bank", comment: "")
    static let creditCard = NSLocalizedString("CreditCard", comment: "")
    static let description = NSLocalizedString("Description", comment: "")
    static let addDescription  = NSLocalizedString("AddDescription", comment: "")
    static let enterAmount = NSLocalizedString("Please_enter_amount", comment: "")
    static let chooseCategory = NSLocalizedString("Please_choose_category", comment: "")
}

// MARK: - Expense Category
extension String {
    static let breakfast = NSLocalizedString("Breakfast", comment: "")
    static let lunch = NSLocalizedString("Lunch", comment: "")
    static let dinner = NSLocalizedString("Dinner", comment: "")
    static let drink = NSLocalizedString("Drink", comment: "")
    static let snacks = NSLocalizedString("Snacks", comment: "")
    static let traffic = NSLocalizedString("Traffic", comment: "")
    static let grocery = NSLocalizedString("Grocery", comment: "")
    static let entertainment = NSLocalizedString("Entertainment", comment: "")
    static let clothes = NSLocalizedString("Clothes", comment: "")
    static let social = NSLocalizedString("Social", comment: "")
    static let bill = NSLocalizedString("Bill", comment: "")
    static let rent = NSLocalizedString("Rent", comment: "")
    static let shopping = NSLocalizedString("Shopping", comment: "")
    static let gift = NSLocalizedString("Gift", comment: "")
    static let medical = NSLocalizedString("Medical", comment: "")
    static let insurance = NSLocalizedString("Insurance", comment: "")
    static let investment = NSLocalizedString("Investment", comment: "")
    static let transfer = NSLocalizedString("Transfer", comment: "")
    static let utilities = NSLocalizedString("Utilities", comment: "")
}

// MARK: - Income Category
extension String {
    static let salary = NSLocalizedString("Salary", comment: "")
    static let bonus = NSLocalizedString("Bonus", comment: "")
    static let allowance = NSLocalizedString("Allowance", comment: "")
    static let invest = NSLocalizedString("Invest", comment: "")
}
