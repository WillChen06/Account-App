//
//  Category.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/28.
//  Copyright © 2017年 william. All rights reserved.
//

import Foundation
class Category {
    struct Expense {
        var name: [String] {
            return [.breakfast, .traffic, .lunch, .grocery, .dinner, .entertainment, .drink, .clothes, .snacks, .social, .bill, .rent, .shopping, .gift, .medical, .insurance, .investment, .transfer, .utilities, .other]
        }
        var imageName: [String] {
            return ["breakfast", "traffic", "lunch", "grocery", "dinner", "entertainment", "drink", "clothes", "snacks", "social", "bill", "rent", "shopping", "gift", "medical", "insurance", "investment", "transfer", "utilities", "other"]
        }
    }
    struct Income {
        var name: [String] {
            return [.salary, .bonus, .allowance, .invest,.other]
        }
        var imageName: [String] {
            return ["salary", "bonus", "allowance", "invest", "other"]
        }
    }
}

