//
//  SumDisplayView.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/22.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit
class SumDisplayView: UIView {
    
    lazy var displayDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var totalTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = .listTitleGray
        label.textAlignment = .center
        label.text = .total
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var expenseTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = .listTitleGray
        label.textAlignment = .center
        label.text = .expenses
        return label
    }()
    
    lazy var sumOfExpenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var incomeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = .listTitleGray
        label.textAlignment = .center
        label.text = .income
        return label
    }()
    
    lazy var sumOfIncomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var separateView: UIView = {
        let separateView = UIView()
        separateView.translatesAutoresizingMaskIntoConstraints = false
        separateView.backgroundColor = .listSeparateBlue
        return separateView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented.")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .listDisplayBlue
        addSubview(displayDateLabel)
        addSubview(totalTitle)
        addSubview(totalLabel)
        addSubview(expenseTitle)
        addSubview(sumOfExpenseLabel)
        addSubview(incomeTitle)
        addSubview(sumOfIncomeLabel)
        addSubview(separateView)
        displayDateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        totalTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalTitle.anchor(top: nil, left: nil, bottom: totalLabel.topAnchor, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        totalLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        separateView.anchor(top: nil, left: nil, bottom: self.bottomAnchor, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 24.0, rightConstant: 0.0, widthConstant: 1.0, heightConstant: 0.0)
        separateView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separateView.heightAnchor.constraint(equalTo: sumOfExpenseLabel.heightAnchor, multiplier: 1.0).isActive = true
        expenseTitle.anchor(top: nil, left: self.leftAnchor, bottom: sumOfExpenseLabel.topAnchor, right: nil, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        expenseTitle.widthAnchor.constraint(equalTo: sumOfExpenseLabel.widthAnchor, multiplier: 1.0).isActive = true
        sumOfExpenseLabel.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: separateView.leftAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 16.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        incomeTitle.anchor(top: nil, left: nil, bottom: sumOfIncomeLabel.topAnchor, right: self.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        incomeTitle.widthAnchor.constraint(equalTo: sumOfIncomeLabel.widthAnchor, multiplier: 1.0).isActive = true
        sumOfIncomeLabel.anchor(top: nil, left: separateView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 16.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        sumOfExpenseLabel.widthAnchor.constraint(equalTo: sumOfIncomeLabel.widthAnchor, multiplier: 1.0).isActive = true
        
    }
}
