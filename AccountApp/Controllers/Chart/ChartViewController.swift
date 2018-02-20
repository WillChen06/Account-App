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
    
    lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(ChartListCell.self, forCellReuseIdentifier: String(describing: ChartListCell.self))
        return tableView
    }()
    
    enum Interval {
        case year
        case month
        case week
        case day
    }
    
    var switchTag = 0
    var currentType: Interval = .day
    var showExpense: Bool = true
    var chartDictionary: [String : Int] = [:]
    var colorsData: [UIColor] = {
        return ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    }()
    var accounts: Results<Account>? = {
        return RealmHelper.objects(Account.self)
    }()
    var total = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if showExpense {
            setupChartView(chartView: chartView, by: currentType)
        } else {
            setupIncomeChartView(chartView: incomeChartView, by: currentType)
        }
    }
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(internalSwitchView)
        view.addSubview(displayDateLabel)
        view.addSubview(chartScrollView)
        view.addSubview(listTableView)
        chartScrollView.addSubview(chartView)
        chartScrollView.addSubview(incomeChartView)
        displayDateLabel.text = getDateOfInterval(.day)
        if #available(iOS 11, *) {
            internalSwitchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        } else {
           internalSwitchView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        }
        
        displayDateLabel.anchor(top: internalSwitchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        chartScrollView.anchor(top: displayDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        chartView.anchor(top: chartScrollView.topAnchor, left: chartScrollView.leftAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        chartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        chartView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        incomeChartView.frame.origin.x = view.frame.size.width
        incomeChartView.anchor(top: chartScrollView.topAnchor, left: chartView.rightAnchor, bottom: nil, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        incomeChartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        incomeChartView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        
        listTableView.anchor(top: chartScrollView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        listTableView.heightAnchor.constraint(equalTo: chartScrollView.heightAnchor, multiplier: 0.4).isActive = true
    }
    private func setupNavigation() {
        navigationItem.title = .expenses
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
    }
    
    private func setupChartView(chartView: PieChartView, by interval: Interval) {
        let data = getSumOfAccounts(type: "Expense", by: interval)
        setup(pieChartView: chartView)
        chartView.delegate = self
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont.systemFont(ofSize: 12.0)
        setDataCount(data, isExpense: true)
        chartView.animate(xAxisDuration: 1.3, easingOption: .easeOutBack)
        listTableView.reloadData()
    }
    
    private func setupIncomeChartView(chartView: PieChartView, by interval: Interval) {
        let data = getSumOfAccounts(type: "Income", by: interval)
        setup(pieChartView: incomeChartView)
        chartView.delegate = self
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont.systemFont(ofSize: 12.0)
        setDataCount(data, isExpense: false)
        chartView.animate(xAxisDuration: 1.3, easingOption: .easeOutBack)
        listTableView.reloadData()
    }
    
    func setDataCount(_ data: [String : Int], isExpense: Bool) {
        
        let entries = (0..<data.count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(Array(data)[i].value),
                                     label: Array(data)[i].key,
                                     icon: nil)
        }
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = colorsData
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        if isExpense {
            chartView.data = data
            chartView.highlightValues(nil)
        } else {
            incomeChartView.data = data
            incomeChartView.highlightValues(nil)
        }
       
    }
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.6
//        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText: NSMutableAttributedString
        if showExpense {
            centerText = NSMutableAttributedString(string: .expenses + "\n" + String(describing: total))
        } else {
            centerText = NSMutableAttributedString(string: .income + "\n" + String(describing: total))
        }
        centerText.setAttributes([.font : UIFont.systemFont(ofSize: 17.0),
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 270
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
                self.displayDateLabel.text = self.getDateOfInterval(.year)
                if self.showExpense {
                    self.setupChartView(chartView: self.chartView, by: .year)
                } else {
                    self.setupIncomeChartView(chartView: self.incomeChartView, by: .year)
                }
            })
        }
    }

    @objc private func switchToMonth() {
        if switchTag != 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 1
                self.currentType = .month
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.monthButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.month)
                if self.showExpense {
                    self.setupChartView(chartView: self.chartView, by: .month)
                } else {
                    self.setupIncomeChartView(chartView: self.incomeChartView, by: .month)
                }
            })
        }
    }
    
    @objc private func switchToWeek() {
        if switchTag != 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 2
                self.currentType = .week
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.weekButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.week)
                if self.showExpense {
                    self.setupChartView(chartView: self.chartView, by: .week)
                } else {
                    self.setupIncomeChartView(chartView: self.incomeChartView, by: .week)
                }
            })
        }
    }
    
    @objc private func switchToDay() {
        if switchTag != 3 {
            UIView.animate(withDuration: 0.3, animations: {
                self.switchTag = 3
                self.currentType = .day
                self.internalSwitchView.currentView.frame.origin.x = self.internalSwitchView.dayButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.day)
                if self.showExpense {
                    self.setupChartView(chartView: self.chartView, by: .day)
                } else {
                    self.setupIncomeChartView(chartView: self.incomeChartView, by: .day)
                }
            })
        }
    }
    
    func getDateOfInterval(_ range: Interval) -> String {
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
    
    func getSumOfAccounts(type: String, by interval: Interval) -> [String : Int] {
        let data: Results<Account>?
        switch interval {
        case .day:
            data = accounts?.filter("type == %@ && date == %@", type, Date().startOfDay!)
        case .week:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", type, Date().startOfWeek!, Date().endOfWeek!)
        case .month:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", type, Date().startOfMonth!, Date().endOfMonth!)
        case .year:
            data = accounts?.filter("type == %@ && (date >= %@ && date <= %@)", type, Date().startOfYear!, Date().endOfYear!)
        }
        let result = data?.group{ $0.category.value! }
        var name = ""
        chartDictionary = [:]
        for item in result! {
            let sum = item.reduce(0, { (result, account) -> Int in
                return result + Int(account.amount)!
            })
            switch type {
            case "Expense":
                name = Category.Expense().name[(item.first?.category.value)!]
                chartDictionary[name] = sum
            case "Income":
                name = Category.Income().name[(item.first?.category.value)!]
                chartDictionary[name] = sum
            default:
                break
            }
        }
        total = chartDictionary.reduce(0, { (result, dict) -> Int in
            return result + dict.value
        })
        return chartDictionary
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
        let position = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        if Int(position) == 0 && !showExpense {
            DispatchQueue.main.async {
                self.navigationItem.title = .expenses
                self.setupChartView(chartView: self.chartView, by: self.currentType)
            }
            showExpense = true
        } else if Int(position) == 1 && showExpense {
            DispatchQueue.main.async {
                self.navigationItem.title = .income
                self.setupIncomeChartView(chartView: self.incomeChartView, by: self.currentType)
            }
            showExpense = false
        }
    }
}

// MARK: - TableView protocol
extension ChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartDictionary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChartListCell.self), for: indexPath) as? ChartListCell else {
            return UITableViewCell()
        }
        cell.typeImageView.backgroundColor = colorsData[indexPath.row]
        cell.nameLabel.text = Array(chartDictionary)[indexPath.row].key
        cell.amountLabel.text = String(describing: Array(chartDictionary)[indexPath.row].value)
        return cell
    }
}

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
