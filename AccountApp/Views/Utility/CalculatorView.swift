//
//  CalculatorView.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/21.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit

class CalculatorView: UIView {
    // MARK: Properties
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var mutiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
//    @IBOutlet weak var hundredButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    @IBOutlet weak var equlButton: UIButton!
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    
    var delegate: AddAccountViewControllerDelegate?
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CalculatorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let buttons: [UIButton] = [number0, number1, number2, number3, number4, number5, number6, number7, number8, number9, equlButton, clearButton, divideButton, mutiplyButton, minusButton, additionButton, decimalButton]
        for button in buttons {
            button.addTarget(self, action: #selector(inputAmount(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeToEqual), name: .changeToEqual, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToOk), name: .changeToOk, object: nil)
    }
    
    // MARK: - Actions
    @objc func inputAmount(_ sender: UIButton) {
        delegate?.inputAmount(sender)
    }

    @objc func changeToEqual() {
        equlButton.setTitle("=", for: .normal)
    }
    
    @objc func changeToOk() {
        equlButton.setTitle("OK", for: .normal)
    }

}
