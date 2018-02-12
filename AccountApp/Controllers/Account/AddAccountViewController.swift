//
//  AddAccountViewController.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/20.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit

protocol AddAccountViewControllerDelegate {
    func switchToExpense(_ sender: UIButton)
    func switchToIncome(_ sender: UIButton)
    func inputAmount(_ sender: UIButton)
    func addDescription(_ description: String)
    func dismiss()
}

extension AddAccountViewControllerDelegate {
    func switchToExpense(_ sender: UIButton) { }
    
    func switchToIncome(_ sender: UIButton) { }
    
    func inputAmount(_ sender: UIButton) { }
    
    func addDescription(_ description: String) { }
    
    func dismiss() { }
    
}

class AddAccountViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var typeView: TypeSwitchView! {
        didSet {
            typeView.delegate = self
        }
    }
    @IBOutlet weak var expensesView: UIView! {
        didSet {
            expensesView.isHidden = false
        }
    }
    @IBOutlet weak var incomeView: UIView! {
        didSet {
            incomeView.isHidden = true
        }
    }
    
    var delegate: AccountViewControllerDelegate?
    var date = Date()
    var typeTag = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController), name: .dismissVC, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: .cancel, style: .plain, target: self, action: #selector(dismissController))
        ]
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: .save, style: .plain, target: self, action: #selector(save))
        ]
    }
    
    // MARK: - Actions
//    @IBAction func switchType(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            NotificationCenter.default.post(name: .clearIncome, object: nil)
//            expensesView.isHidden = false
//            incomeView.isHidden = true
//        case 1:
//            NotificationCenter.default.post(name: .clearExpenses, object: nil)
//            expensesView.isHidden = true
//            incomeView.isHidden = false
//        default:
//            break
//        }
//    }
    
    @objc func dismissController() {
        NotificationCenter.default.post(name: .clearExpenses, object: nil)
        NotificationCenter.default.removeObserver(self, name: .dismissVC, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        if typeTag == 0 {
            NotificationCenter.default.post(name: .saveExpenses, object: nil)
        } else {
            NotificationCenter.default.post(name: .saveIncome, object: nil)
        }
        delegate?.updateCalendarData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddExpenseSegue" {
            let addexpenseVC = segue.destination as! AddExpensesViewController
            addexpenseVC.date = date
        } else if segue.identifier == "AddIncomeSegue" {
            let addIncomeVC = segue.destination as! AddIncomeViewController
            addIncomeVC.date = date
        }
    }
    
}

extension AddAccountViewController: AddAccountViewControllerDelegate {
    func switchToExpense(_ sender: UIButton) {
        if typeTag != 0 {
            typeTag = 0
            NotificationCenter.default.post(name: .clearIncome, object: nil)
            expensesView.isHidden = false
            incomeView.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.typeView.currentView.frame.origin.x = self.typeView.expensesButton.frame.origin.x
            })
        }
    }
    func switchToIncome(_ sender: UIButton) {
        if typeTag != 1 {
            typeTag = 1
            NotificationCenter.default.post(name: .clearExpenses, object: nil)
            expensesView.isHidden = true
            incomeView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.typeView.currentView.frame.origin.x = self.typeView.incomeButton.frame.origin.x
            })
        }
    }
}
