//
//  AccountViewController.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/17.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift

//protocol AccountViewControllerDelegate {
//    func updateCalendarData()
//}

class AccountViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var currentDateButton: UIButton!
    
    // MARK: - Properties
    var dateFormatter = DateFormatter()
    var selectedDate = Date()
    var accounts: Results<Account>? = {
        let accounts = RealmHelper.objects(Account.self)
        return accounts
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalendarData), name: .updateCalendar, object: nil)
        setupViews()
        print("Paths : \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Setup
    private func setupViews() {
        yearLabel.text = getMonthYearString(Date())

        currentDateButton.setTitle(.today, for: .normal)
        currentDateButton.setTitleColor(.white, for: .normal)
        currentDateButton.applyViewGradient(colors: [.brightCyan, .softBlue])
        currentDateButton.layer.cornerRadius = 5.0
        currentDateButton.clipsToBounds = true
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(selectedDate)
        calendarView.selectDates([selectedDate])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(AccountDisplayCell.self, forCellReuseIdentifier: String(describing: AccountDisplayCell.self))
    }
    
    func getMonthYearString(_ date: Date) -> String {
        let month = Calendar.current.dateComponents([.month], from: date).month!
        let monthName = DateFormatter().monthSymbols[(month - 1) % 12]
        let year = Calendar.current.component(.year, from: date)
        return monthName + " " + String(describing: year)
    }
    
    func setupCalendarView(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month - 1) % 12]
        let year = Calendar.current.component(.year, from: startDate)
        yearLabel.text = monthName + " " + String(describing: year)
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let customCell = cell as? CalendarDateCell else { return }
        handleCellTextColor(cell: customCell, cellState: cellState)
        handleCellSelection(cell: customCell, cellState: cellState)
    }
    func handleCellTextColor(cell: CalendarDateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLbael.textColor = .black
        } else {
            cell.dateLbael.textColor = .gray
        }
    }
    func handleCellSelection(cell: CalendarDateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
    }
    
    // MARK: - Action

    @IBAction func addAccount(_ sender: UIBarButtonItem) {
        let addAccountVC = UIStoryboard(name: "AddAccount", bundle: nil).instantiateViewController(withIdentifier: "AddAccountViewController") as? AddAccountViewController
        addAccountVC?.date = selectedDate
        let navigationVC = UINavigationController(rootViewController: addAccountVC!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func getCurrentDate(_ sender: UIButton) {
        calendarView.deselectAllDates()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    }
    
    @objc func updateCalendarData() {
        calendarView.reloadData()
        tableView.reloadData()
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

// MARK: - JTAppleCalendar Protocol
extension AccountViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date().create(year: 1993, month: 1, day: 1)
        let endDate = Date().create(year: 2120, month: 12, day: 31)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarDateCell.self), for: indexPath) as? CalendarDateCell else {
            return JTAppleCell()
        }
        cell.selectView.isHidden = true
        cell.dataView.isHidden = !RealmHelper.isContain(cellState.date)
        configureCell(cell: cell, cellState: cellState)
        cell.dateLbael.text = cellState.text
        return cell
    }
}

extension AccountViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("Called Will Display")
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo != .thisMonth {
            return false
        }
        return true
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarView(from: visibleDates)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("Did Select")
        selectedDate = cellState.date
        configureCell(cell: cell, cellState: cellState)
        accounts = RealmHelper.objects(Account.self)?.filter("date == %@", selectedDate)
        tableView.reloadData()
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("Deselect")
        configureCell(cell: cell, cellState: cellState)
    }
}

// MARK: - UITableView Protocol
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (accounts?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountDisplayCell.self), for: indexPath) as? AccountDisplayCell else {
            return UITableViewCell()
        }
        let account = (accounts?.sorted(byKeyPath: "type"))![indexPath.row]
        if account.type == "Expense" {
            cell.titleLabel.text = Category.Expense().name[account.category.value!]
            cell.typeImageView.image = UIImage(named: "down")
        } else {
            cell.titleLabel.text = Category.Income().name[account.category.value!]
            cell.typeImageView.image = UIImage(named: "up")
        }
        cell.amountLabel.text = account.amount
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountDisplayCell else {
            return
        }
        if Category.Expense().name.contains(cell.titleLabel.text!) {
            
            let expenseVC = AddExpensesViewController()
            let navigationVC = UINavigationController(rootViewController: expenseVC)
            expenseVC.account = accounts?.sorted(byKeyPath: "type")[indexPath.row]
            expenseVC.newMode = false
            present(navigationVC, animated: true, completion: nil)
        }
        if Category.Income().name.contains(cell.titleLabel.text!){
            let incomeVC = AddIncomeViewController()
            let navigationVC = UINavigationController(rootViewController: incomeVC)
            incomeVC.account = accounts?.sorted(byKeyPath: "type")[indexPath.row]
            incomeVC.newMode = false
            present(navigationVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Account Protocol
//extension AccountViewController: AccountViewControllerDelegate {
//    func updateCalendarData() {
//        calendarView.reloadData()
//        tableView.reloadData()
//    }
//}

