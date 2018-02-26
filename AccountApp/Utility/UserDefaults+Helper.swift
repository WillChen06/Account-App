//
//  UserDefaults+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/25.
//  Copyright © 2018年 william. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setNotificationMode(_ value: Bool) {
        set(value, forKey: "NotificationMode")
    }
    func isNotificationMode() -> Bool {
        return bool(forKey: "NotificationMode")
    }
}
