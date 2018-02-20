//
//  TypeSwitchView.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/12.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class TypeSwitchView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var currentView: UIView!
    var delegate: AddAccountViewControllerDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("TypeSwitchView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        expensesButton.setTitle(.expenses, for: .normal)
        expensesButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        incomeButton.setTitle(.income, for: .normal)
        incomeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
    }

    // MARK: - Actions
    @IBAction func switchToExpense(_ sender: UIButton) {
        delegate?.switchToExpense(sender)
    }
    @IBAction func switchToIncome(_ sender: UIButton) {
        delegate?.switchToIncome(sender)
    }
    
}
