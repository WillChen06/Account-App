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
    
    lazy var intervalSwitchView: IntervalSwitchView = {
        let switchView = IntervalSwitchView()
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
    
    lazy var chartScrollView: CustomChartViews = {
        let chartViews = CustomChartViews()
        chartViews.translatesAutoresizingMaskIntoConstraints = false
        chartViews.delegate = self
        chartViews.contentSize = CGSize(width: view.frame.size.width * 3, height: 0.0)
        chartViews.isPagingEnabled = true
        chartViews.showsHorizontalScrollIndicator = false
        chartViews.showsVerticalScrollIndicator = false
        return chartViews
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
    
    var position: CGFloat {
        let position = round(chartScrollView.contentOffset.x / chartScrollView.frame.size.width)
        guard !position.isNaN else {
            return 0
        }
        return position
    }
    
    var currentType: Interval = .day
    var chartDictionary: [String : Int] = [:]
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
        switch position {
        case 0:
            setupChartView(category: "Expense", by: currentType)
        case 1:
            setupChartView(category: "Income", by: currentType)
        case 2:
            print("Total Display")
        default:
            break
        }
    }
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(intervalSwitchView)
        view.addSubview(displayDateLabel)
        view.addSubview(chartScrollView)
        view.addSubview(listTableView)
        displayDateLabel.text = getDateOfInterval(.day)
        if #available(iOS 11, *) {
            intervalSwitchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        } else {
            intervalSwitchView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        }
        
        displayDateLabel.anchor(top: intervalSwitchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        chartScrollView.anchor(top: displayDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        
        listTableView.anchor(top: chartScrollView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        listTableView.heightAnchor.constraint(equalTo: chartScrollView.heightAnchor, multiplier: 0.4).isActive = true

    }
    private func setupNavigation() {
        navigationItem.title = .expenses
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
    }
    
    private func setupChartView(category: String, by interval: Interval) {
        let data = getSumOfAccounts(type: category, by: interval)
        chartScrollView.setupChartView(in: category)
        chartScrollView.setData(data, in: category)
        listTableView.reloadData()
    
    }
    
    // MARK: - Actions
    
    @objc private func switchToYear() {
        if currentType != .year {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .year
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.yearButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.year)
                switch self.position {
                case 0:
                    self.setupChartView(category: "Expense", by: .year)
                case 1:
                    self.setupChartView(category: "Income", by: .year)
                default:
                    break
                }
            })
        }
    }
    
    @objc private func switchToMonth() {
        if currentType != .month {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .month
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.monthButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.month)
                switch self.position {
                case 0:
                    self.setupChartView(category: "Expense", by: .month)
                case 1:
                    self.setupChartView(category: "Income", by: .month)
                default:
                    break
                }
            })
        }
    }
    
    @objc private func switchToWeek() {
        if currentType != .week {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .week
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.weekButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.week)
                switch self.position {
                case 0:
                    self.setupChartView(category: "Expense", by: .week)
                case 1:
                    self.setupChartView(category: "Income", by: .week)
                default:
                    break
                }
            })
        }
    }
    
    @objc private func switchToDay() {
        if currentType != .day {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .day
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.dayButton.frame.origin.x
                self.displayDateLabel.text = self.getDateOfInterval(.day)
                switch self.position {
                case 0:
                    self.setupChartView(category: "Expense", by: .day)
                case 1:
                    self.setupChartView(category: "Income", by: .day)
                default:
                    break
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
}

// MARK: - ScrollView protocol
extension ChartViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch position {
        case 0:
            self.navigationItem.title = .expenses
            self.setupChartView(category: "Expense", by: self.currentType)
        case 1:
            self.navigationItem.title = .income
            self.setupChartView(category: "Income", by: self.currentType)
        case 2:
            self.navigationItem.title = .total
        default:
            break
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
        let amount = Double(Array(chartDictionary)[indexPath.row].value)
        cell.typeImageView.backgroundColor = CustomChartViews.colors[indexPath.row]
        cell.nameLabel.text = Array(chartDictionary)[indexPath.row].key
        cell.percentageLabel.text = (amount / Double(total)).toPercentage
        cell.amountLabel.text = String(describing: amount)
        return cell
    }
}

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
