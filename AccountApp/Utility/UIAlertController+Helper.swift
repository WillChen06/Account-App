//
//  UIAlertController+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/01/21.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addAction(title: String?, style: UIAlertActionStyle, handler:((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
}
