//
//  CustomChartViews.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/04/23.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit
import Foundation
import Charts

class CustomChartViews: UIScrollView {
    static var colors: [UIColor] {
        return ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    }
    
    lazy var expenseChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.legend.enabled = false
        return chartView
    }()
    
    lazy var incomeChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.legend.enabled = false
        return chartView
    }()
    
    lazy var totalView: UIView = {
        let totalView = UIView()
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.backgroundColor = .cyan
        return totalView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been impelement.")
    }
    
    fileprivate func setupViews() {
        addSubview(expenseChartView)
        addSubview(incomeChartView)
        addSubview(totalView)
        
        expenseChartView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        expenseChartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        expenseChartView.heightAnchor.constraint(equalTo: expenseChartView.widthAnchor, multiplier: 1.0).isActive = true
        
        incomeChartView.frame.origin.x = frame.size.width
        incomeChartView.anchor(top: topAnchor, left: expenseChartView.rightAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        incomeChartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        incomeChartView.heightAnchor.constraint(equalTo: incomeChartView.widthAnchor, multiplier: 1.0).isActive = true
        
        totalView.frame.origin.x = frame.size.width * 2
        totalView.anchor(top: topAnchor, left: incomeChartView.rightAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        totalView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        totalView.heightAnchor.constraint(equalTo: totalView.widthAnchor, multiplier: 1.0).isActive = true
      
    }
    
}

extension CustomChartViews {
    
    
    func setupChartView(in category: String) {
        switch category {
        case "Expense":
            expenseChartView.holeRadiusPercent = 0.7
            expenseChartView.chartDescription?.enabled = false
            expenseChartView.rotationEnabled = false
            expenseChartView.highlightPerTapEnabled = false
        case "Income":
            incomeChartView.holeRadiusPercent = 0.7
            incomeChartView.chartDescription?.enabled = false
            incomeChartView.rotationEnabled = false
            incomeChartView.highlightPerTapEnabled = false
        default:
            break
        }
        
    }
    
    func setData(_ data: [String : Int], in category: String) {
        let entries = (0..<data.count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(Array(data)[i].value))
        }
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.colors = CustomChartViews.colors
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.drawValuesEnabled = false
        let data = PieChartData(dataSet: set)
        switch category {
        case "Expense":
            expenseChartView.data = data
            expenseChartView.highlightValues(nil)
            expenseChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
        case "Income":
            incomeChartView.data = data
            incomeChartView.highlightValues(nil)
            incomeChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
//        case "Total":
        default:
            break
        }
    }
}

