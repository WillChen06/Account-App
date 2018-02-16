//
//  ChartViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/12.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ChartViewController: UIViewController {

    // MARK: - Properties
    
    lazy var internalSwitchView: InternalSwitchView = {
        let switchView = InternalSwitchView()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.yearButton.addTarget(self, action: #selector(switchToYear), for: .touchUpInside)
        switchView.monthButton.addTarget(self, action: #selector(switchToMonth), for: .touchUpInside)
        switchView.weekButton.addTarget(self, action: #selector(switchToWeek), for: .touchUpInside)
        switchView.dayButton.addTarget(self, action: #selector(switchToDay), for: .touchUpInside)
        return switchView
    }()
    
    lazy var displayDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var chartScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
//        scrollView.backgroundColor = .softBlue
        scrollView.contentSize = CGSize(width: view.frame.size.width * 2, height: 0.0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var chartView: PieChartView = {
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
    enum Internal {
        case year
        case month
        case week
        case day
    }
    
    var switchTag = 0
    var currentType: Internal = .day
    var accounts: Results<Account>? = {
        return RealmHelper.objects(Account.self)
    }()
   
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Change To ChartView")
        setupViews()
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Call viewWillAppear")
        setupChartView(chartView: chartView, by: .day)
        
    }
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(internalSwitchView)
        view.addSubview(displayDateLabel)
        view.addSubview(chartScrollView)
        chartScrollView.addSubview(chartView)
        chartScrollView.addSubview(incomeChartView)
        displayDateLabel.text = getDateOfInternal(.day)
        if #available(iOS 11, *) {
            internalSwitchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        } else {
           internalSwitchView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        }
        
        displayDateLabel.anchor(top: internalSwitchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        
        chartScrollView.anchor(top: displayDateLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8.0, leftConstant: 0.0, bottomConstant: 66.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        chartView.anchor(top: chartScrollView.topAnchor, left: chartScrollView.leftAnchor, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        chartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        chartView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        incomeChartView.frame.origin.x = view.frame.size.width
        incomeChartView.anchor(top: chartScrollView.topAnchor, left: chartView.rightAnchor, bottom: nil, right: nil, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        incomeChartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        incomeChartView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
    }
    private func setupNavigation() {
        navigationItem.title = .expenses
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
    }
    
    private func setupChartView(chartView: PieChartView, by type: Internal) {
        if accounts == nil { return }
        let data: Results<Account>?
        switch type {
        case .day:
            data = accounts?.filter("type == %@ && date == %@", "Expense", Date().startOfDay!)
        case .week:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", "Expense", Date().startOfWeek!, Date().endOfWeek!)
        case .month:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", "Expense", Date().startOfMonth!, Date().endOfMonth!)
        case .year:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", "Expense", Date().startOfYear!, Date().endOfYear!)
        }
        setup(pieChartView: chartView)
        chartView.delegate = self
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont.systemFont(ofSize: 12.0)
        setDataCount(data)
        chartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func setDataCount(_ data: Results<Account>?) {
        
        let entries = (0..<(data?.count)!).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(data![i].amount)!,
                                     label: Category.Expense().name[data![i].category.value!],
                                     icon: nil)
        }
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func switchToYear() {
        if switchTag != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 0
                self.currentType = .year
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.yearButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInternal(.year)
                self.setupChartView(chartView: self.chartView, by: .year)
            })
        }
    }

    @objc private func switchToMonth() {
        if switchTag != 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 1
                self.currentType = .month
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.monthButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInternal(.month)
                self.setupChartView(chartView: self.chartView, by: .month)
            })
        }
    }
    
    @objc private func switchToWeek() {
        if switchTag != 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 2
                self.currentType = .week
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.weekButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInternal(.week)
                self.setupChartView(chartView: self.chartView, by: .week)
            })
        }
    }
    
    @objc private func switchToDay() {
        if switchTag != 3 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 3
                self.currentType = .day
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.dayButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInternal(.day)
                self.setupChartView(chartView: self.chartView, by: .day)
            })
        }
    }
    
    func getDateOfInternal(_ range: Internal) -> String {
        switch range {
        case .year:
            let start = Date().startOfYear?.toString(format: "yyyy/MM/dd")
            let end = Date().endOfYear?.toString(format: "yyyy/MM/dd")
            return start! + "~" + end!
        case .month:
            let start = Date().startOfMonth?.toString(format: "yyyy/MM/dd")
            let end = Date().endOfMonth?.toString(format: "yyyy/MM/dd")
            return start! + "~" + end!
        case .week:
            let start = Date().startOfWeek?.toString(format: "yyyy/MM/dd")
            let end = Date().endOfWeek?.toString(format: "yyyy/MM/dd")
            return start! + "~" + end!
        case .day:
            return Date().toString(format: "yyyy/MM/dd")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Chart protocol
extension ChartViewController: ChartViewDelegate {
    
}

// MARK: - ScrollView protocol
extension ChartViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
