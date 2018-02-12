//
//  AddIncomeViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/01/31.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class AddIncomeViewController: UIViewController {
    
    // MARK: - Properties
    lazy var amountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 100.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(showCalculatorView(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IncomCell.self, forCellWithReuseIdentifier: String(describing: IncomCell.self))
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var accountTypeView: UIView = {
        let typeView = UIView(frame: CGRect(x: 0.0, y: view.frame.size.height, width: view.frame.size.width, height: 217.0 + 44.0))
        typeView.backgroundColor = .white
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let doneButton = UIBarButtonItem(title: .done, style: .plain, target: self, action: #selector(hidePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        pickerView = UIPickerView(frame: CGRect(x: 0.0, y: 44.0, width: view.frame.size.width, height: 217.0))
        pickerView.dataSource = self
        pickerView.delegate = self
        typeView.addSubview(toolBar)
        typeView.addSubview(pickerView)
        return typeView
    }()
    lazy var calculatorView: CalculatorView = {
        let calculatorView = CalculatorView(frame: CGRect(x: 0.0, y: view.frame.size.height, width: view.frame.size.width, height: view.frame.size.height * 0.75))
        calculatorView.delegate = self
        return calculatorView
    }()
    
    var pickerView: UIPickerView!
    var isShowCalculatorView: Bool = false
    var isSelectedCategory: Bool = false
    var date: Date?
    var category: Int?
    var accountType: Int = 0
    var detail: String?
    let pickerItems: [String] = [.cash, .bank, .creditCard]
    var calculator = Calculator()
    var account: Account?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
        setupNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .saveIncome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearData), name: .clearIncome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideCalculator), name: .hideCalculator, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Set up
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(amountButton)
        view.addSubview(categoryCollectionView)
        view.addSubview(tableView)
        view.addSubview(calculatorView)
        view.addSubview(accountTypeView)
        category = account?.category.value
        amountButton.setTitle(account?.amount ?? "0", for: .normal)
        pickerView.selectRow(account?.account ?? 0, inComponent: 0, animated: false)
        if #available(iOS 11.0, *) {
            amountButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 100.0)
            tableView.anchor(top: categoryCollectionView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        } else {
            amountButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 100.0)
            tableView.anchor(top: categoryCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        }
        categoryCollectionView.anchor(top: amountButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        categoryCollectionView.heightAnchor.constraint(equalTo: tableView.heightAnchor, multiplier: 1 / 3).isActive = true
    }
    
    private func setupGesture() {
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down]
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            swipe.direction = direction
            swipe.delegate = self
            view.addGestureRecognizer(swipe)
        }
    }
    
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
    
    @objc func showCalculatorView(_ sender: UIButton) {
        if isShowCalculatorView {
            hideCalculatorView()
        } else {
            view.endEditing(true)
            hidePickerView()
            let cellRect = sender.frame
            UIView.animate(withDuration: 0.5, animations: {
                self.calculatorView.frame = CGRect(x: 0.0, y: cellRect.origin.y + cellRect.size.height, width: self.view.frame.size.width, height: (self.view.frame.size.height - (cellRect.origin.y + cellRect.size.height)))
            })
            isShowCalculatorView = true
        }
    }
    
    private func hideCalculatorView() {
        let cellRect = amountButton.frame
        isShowCalculatorView = false
        UIView.animate(withDuration: 0.5) {
            self.calculatorView.frame = CGRect(x: 0.0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: (self.view.frame.size.height - (cellRect.origin.y + cellRect.size.height)))
        }
    }
    
    @objc func hideCalculator() {
        hideCalculatorView()
    }
    
    private func showPickerView() {
        view.endEditing(true)
        hideCalculatorView()
        UIView.animate(withDuration: 0.5) {
            self.accountTypeView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 217.0 - 44.0, width: self.view.frame.size.width, height: 217.0 + 44.0)
        }
    }
    
    @objc func hidePickerView() {
        
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    func showAddDescriptionView(_ inputString: String) {
        let addDescriptionVC = AddDescriptionViewController()
        addDescriptionVC.delegate = self
        if inputString == .addDescription {
            addDescriptionVC.inputDescription = ""
        } else {
            addDescriptionVC.inputDescription = inputString
        }
        
        let navigationVC = UINavigationController(rootViewController: addDescriptionVC)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @objc func save() {
        if checkInputData() {
            let account = Account()
            account.type = "Income"
            account.date = date!
            account.amount = (amountButton.titleLabel?.text)!
            account.category.value = category
            account.account = accountType
            account.detail = detail
            account.add()
            NotificationCenter.default.removeObserver(self, name: .saveExpenses, object: nil)
            print("Dismiss ViewController First")
            NotificationCenter.default.post(name: .dismissVC, object: nil)
        }
    }

    func checkInputData() -> Bool {
        var title: String?
        if Int((amountButton.titleLabel?.text)!)! <= 0 {
            title = .enterAmount
            let inputAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            inputAlert.addAction(title: .ok, style: .default, handler: nil)
            present(inputAlert, animated: true, completion: nil)
            return false
        }
        if !isSelectedCategory {
            title = .chooseCategory
            let inputAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            inputAlert.addAction(title: .ok, style: .default, handler: nil)
            present(inputAlert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @objc fileprivate func clearData() {
        view.endEditing(true)
        hideCalculatorView()
        hidePickerView()
        calculator.displayValue = String()
        amountButton.setTitle("0", for: .normal)
        var frame = categoryCollectionView.frame
        frame.origin.x = 0.0
        frame.origin.y = 0.0
        categoryCollectionView.scrollRectToVisible(frame, animated: false)
        isShowCalculatorView = false
        isSelectedCategory = false
        category = nil
        accountType = 0
        detail = nil
        categoryCollectionView.reloadData()
        tableView.reloadData()
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    @objc func swipe(_ gesture: UISwipeGestureRecognizer) {
        hideCalculatorView()
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

// MARK: - CollectionView protocol
extension AddIncomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IncomCell.self), for: indexPath) as? IncomCell else {
            return UICollectionViewCell()
        }
        cell.tag = indexPath.row
        cell.nameLabel.text = Category.Income().name[indexPath.row]
        cell.categoryImageView.image = UIImage(named: Category.Income().imageName[indexPath.row])
        if category != nil {
            if cell.tag == category {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        return cell
    }
}

extension AddIncomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? IncomCell
        category = selectedCell?.tag
        isSelectedCategory = true
    }
}

extension AddIncomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.size.width / 5
        let cellHeight = collectionView.frame.size.height - 37.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - TableView protocol
extension AddIncomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = SelectAccountTypeCell()
            cell.typeLabel.text = pickerItems[pickerView.selectedRow(inComponent: 0)]
            return cell
        case 1:
            let cell = AccountDescriptionCell()
            cell.describleLabel.text = account?.detail ?? .addDescription
            if cell.describleLabel.text == .addDescription {
                cell.describleLabel.textColor = .placeholderGrey
            } else {
                cell.describleLabel.textColor = .black
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension AddIncomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        switch indexPath.row {
        case 0:
            showPickerView()
        case 1:
            let cell = tableView.cellForRow(at: indexPath) as? AccountDescriptionCell
            showAddDescriptionView((cell?.describleLabel.text) ?? "")
        default:
            break
            
        }
    }
}

// MARK: - PickerView protocol
extension AddIncomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
}

extension AddIncomeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SelectAccountTypeCell else {
            return
        }
        cell.typeLabel.text = pickerItems[row]
        accountType = row
    }
}

// MARK: - AddAccount protocol
extension AddIncomeViewController: AddAccountViewControllerDelegate {
    func inputAmount(_ sender: UIButton) {
        if let label = sender.titleLabel?.text {
            do {
                try calculator.input(label)
                amountButton.setTitle(calculator.displayValue, for: .normal)
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func addDescription(_ description: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AccountDescriptionCell
        if description == .addDescription {
            cell?.describleLabel.textColor = .placeholderGrey
        } else {
            cell?.describleLabel.textColor = .black
            cell?.describleLabel.text = description
            detail = description
        }
    }
}

// MARK: - Gesture protocol
extension AddIncomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            return true
        } else {
            return false
        }
    }
}