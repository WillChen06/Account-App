//
//  InternalSwitchView.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/13.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class InternalSwitchView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var currentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init hsas not been implemented.")
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("InternalSwitchView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        yearButton.setTitle(.year, for: .normal)
        yearButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        monthButton.setTitle(.month, for: .normal)
        monthButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        weekButton.setTitle(.week, for: .normal)
        weekButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        dayButton.setTitle(.day, for: .normal)
        dayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
    }
}
