//
//  Account.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/20.
//  Copyright © 2017年 william. All rights reserved.
//

import Foundation
import RealmSwift

//class Expense: Object {
//    @objc dynamic var date = Date()
//    @objc dynamic var amount = 0
//    var category = RealmOptional<Int>()
//    @objc dynamic var account = 0
//    @objc dynamic var detail: String? = nil
//}

class Account: Object {
    @objc dynamic var type: String? = nil
    @objc dynamic var date = Date()
    @objc dynamic var amount = "0"
    var category = RealmOptional<Int>()
    @objc dynamic var account = 0
    @objc dynamic var detail: String? = nil

    
}
