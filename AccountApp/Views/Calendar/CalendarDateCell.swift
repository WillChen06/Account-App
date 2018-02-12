//
//  CalendarDateCell.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/17.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDateCell: JTAppleCell {
    @IBOutlet weak var dateLbael: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    override func draw(_ rect: CGRect) {
        selectView.layer.cornerRadius = selectView.bounds.size.width / 2
        dataView.layer.cornerRadius = dataView.bounds.size.width / 2
    }
}
