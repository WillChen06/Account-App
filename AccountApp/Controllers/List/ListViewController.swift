//
//  ListViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/12.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
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
    
    lazy var totalDisplayView: SumDisplayView = {
        let displayView = SumDisplayView()
        displayView.translatesAutoresizingMaskIntoConstraints = false
        return displayView
    }()
    
    lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: String(describing: ListTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var currentType: Interval = .day
    var accounts: Results<Account>? = {
        return RealmHelper.objects(Account.self)
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getSumOfAccounts(by: currentType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(intervalSwitchView)
        view.addSubview(totalDisplayView)
        view.addSubview(listTableView)
        if #available(iOS 11, *) {
            intervalSwitchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        } else {
            intervalSwitchView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 30.0)
        }
        totalDisplayView.anchor(top: intervalSwitchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        totalDisplayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3).isActive = true
        listTableView.anchor(top: totalDisplayView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
    }
    
    // MARK: - Actions
    
    @objc private func switchToYear() {
        if currentType != .year {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .year
                self.getSumOfAccounts(by: .year)
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.yearButton.frame.origin.x
            })
        }
    }
    
    @objc private func switchToMonth() {
        if currentType != .month {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .month
                self.getSumOfAccounts(by: .month)
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.monthButton.frame.origin.x
            })
        }
    }
    
    @objc private func switchToWeek() {
        if currentType != .week {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .week
                self.getSumOfAccounts(by: .week)
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.weekButton.frame.origin.x
            })
        }
    }
    
    @objc private func switchToDay() {
        if currentType != .day {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentType = .day
                self.getSumOfAccounts(by: .day)
                self.intervalSwitchView.currentView.frame.origin.x = self.intervalSwitchView.dayButton.frame.origin.x
            })
        }
    }
    
    func getSumOfAccounts(by interval: Interval) {
        totalDisplayView.displayDateLabel.text = getDateOfInterval(interval)
        var sumOfIncome = 0
        var sumOfExpenses = 0
        var total = 0
        let data: Results<Account>?
        switch interval {
        case .day:
            data = accounts?.filter("date == %@", Date().startOfDay!)
        case .week:
            data = accounts?.filter("date >= %@ && date <= %@", Date().startOfWeek!, Date().endOfWeek!)
        case .month:
            data = accounts?.filter("date >= %@ && date <= %@", Date().startOfMonth!, Date().endOfMonth!)
        case .year:
            data = accounts?.filter("date >= %@ && date <= %@", Date().startOfYear!, Date().endOfYear!)
        }
        
        sumOfIncome = (data?.filter("type == %@", "Income").reduce(0, { (result, account) -> Int in
            return result + Int(account.amount)!
        }))!

        sumOfExpenses = (data?.filter("type == %@", "Expense").reduce(0, { (result, account) -> Int in
            return result + Int(account.amount)!
        }))!
        
        total = sumOfIncome - sumOfExpenses
        
        DispatchQueue.main.async {
            self.totalDisplayView.sumOfExpenseLabel.text = "$" + String(describing: sumOfExpenses)
            self.totalDisplayView.sumOfIncomeLabel.text = "$" + String(describing: sumOfIncome)
            self.totalDisplayView.totalLabel.text = "$" + String(describing: total)
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
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */



// MARK: - TableView protocol
extension ListViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
}
