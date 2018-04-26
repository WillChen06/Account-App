//
//  AddExpensesViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/01/31.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class AddExpensesViewController: UIViewController {
    
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
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(showCalculatorView(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExpenseCell.self, forCellWithReuseIdentifier: String(describing: ExpenseCell.self))
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .placeholderGrey
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    
    lazy var accountTypeView: UIView = {
        let typeView = UIView(frame: CGRect(x: 0.0, y: view.frame.size.height + 34.0, width: view.frame.size.width, height: 217.0 + 44.0))
        typeView.backgroundColor = .white
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let doneButton = UIBarButtonItem(title: .done, style: .plain, target: self, action: #selector(hidePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        pickerView = UIPickerView(frame: CGRect(x: 0.0, y:  44.0, width: view.frame.size.width, height: 217.0))
        pickerView.dataSource = self
        pickerView.delegate = self
        typeView.addSubview(toolBar)
        typeView.addSubview(pickerView)
        return typeView
    }()
    
    lazy var calculatorView: CalculatorView = {
        let calculatorView = CalculatorView(frame: CGRect(x: 0.0, y: view.frame.size.height + 34.0, width: view.frame.size.width, height: view.frame.size.height * 0.75))
        calculatorView.delegate = self
        return calculatorView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(.delete, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        button.isHidden = newMode
        return button
    }()
    
    var pickerView: UIPickerView!
    var isShowCalculatorView: Bool = false
    var isSelectedCategory: Bool = false
    var date: Date?
    var category: Int?
    var accountType: Int = 0
    var detail: String?
    var calculator = Calculator()
    let pickerItems: [String] = [.cash, .bank, .creditCard]
//    var delegate: AddAccountViewControllerDelegate?
//    var delegate: AccountViewControllerDelegate?
    var account: Account?
    var scrollIsDone: Bool = false
    var newMode: Bool = true
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
        setupNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(saveExpenses), name: .saveExpenses, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearData), name: .clearExpenses, object: nil)
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
        view.addSubview(pageControl)
        view.addSubview(tableView)
        view.addSubview(deleteButton)
        view.addSubview(calculatorView)
        view.addSubview(accountTypeView)
        category = account?.category.value
        amountButton.setTitle(account?.amount ?? "0", for: .normal)
        pickerView.selectRow(accountType, inComponent: 0, animated: false)
        if #available(iOS 11.0, *) {
            amountButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 100.0)
            tableView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
            
        } else {
            amountButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 100.0)
            tableView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        }
        categoryCollectionView.anchor(top: amountButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        categoryCollectionView.heightAnchor.constraint(equalTo: tableView.heightAnchor, multiplier: 0.5).isActive = true
        pageControl.anchor(top: categoryCollectionView.bottomAnchor, left: nil, bottom: tableView.topAnchor, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 39.0, heightConstant: 37.0)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        deleteButton.anchor(top: tableView.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 8.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 30.0)
        
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
            UIBarButtonItem(title: .save, style: .plain, target: self, action: #selector(update))
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
            self.calculatorView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + 34.0, width: self.view.frame.size.width, height: (self.view.frame.size.height - (cellRect.origin.y + cellRect.size.height)))
        }
    }
    
    @objc func hideCalculator() {
        hideCalculatorView()
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        var frame = categoryCollectionView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0.0
        categoryCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    private func showPickerView() {
        view.endEditing(true)
        hideCalculatorView()
        UIView.animate(withDuration: 0.5) {
            self.accountTypeView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 217.0 - 44.0, width: self.view.frame.size.width, height: 217.0 + 44.0)
        }
    }
    
    @objc func hidePickerView() {
        UIView.animate(withDuration: 0.5) {
            self.accountTypeView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + 34.0, width: self.view.frame.size.width, height: 217.0 + 44.0)
        }
    }
    
    @objc func swipe(_ gesture: UISwipeGestureRecognizer) {
        hideCalculatorView()
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
    
    @objc func saveExpenses() {
        if checkInputData() {
            let account = Account()
            account.type = "Expense"
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
        pageControl.currentPage = 0
        isShowCalculatorView = false
        isSelectedCategory = false
        category = nil
        accountType = 0
        detail = nil
        categoryCollectionView.reloadData()
        tableView.reloadData()
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func update() {
        if amountButton.titleLabel?.text == "0" {
            let inputAlert = UIAlertController(title: .enterAmount, message: nil, preferredStyle: .alert)
            inputAlert.addAction(title: .ok, style: .default, handler: nil)
            present(inputAlert, animated: true, completion: nil)
        } else {
            account?.update {
                account?.amount = (amountButton.titleLabel?.text)!
                account?.category.value = category
                account?.account = accountType
                account?.detail = detail
                NotificationCenter.default.post(name: .updateCalendar, object: nil)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func deleteData() {
        let deleteAlert = UIAlertController(title: .remind, message: .deleteAlert, preferredStyle: .alert)
        deleteAlert.addAction(title: .ok, style: .default) { (action) in
            self.account?.delete()
            NotificationCenter.default.post(name: .updateCalendar, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        deleteAlert.addAction(title: .cancel, style: .cancel, handler: nil)
        present(deleteAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

// MARK: - TableView protocol
extension AddExpensesViewController: UITableViewDataSource {
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

extension AddExpensesViewController: UITableViewDelegate {
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

// MARK: - CollectionView protocol
extension AddExpensesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExpenseCell.self), for: indexPath) as? ExpenseCell else {
            return UICollectionViewCell()
        }
        cell.tag = indexPath.row
        cell.nameLabel.text = Category.Expense().name[indexPath.row]
        cell.categoryImageView.image = UIImage(named: Category.Expense().imageName[indexPath.row])
        if category != nil {
            if cell.tag == category {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
        return cell
    }
}

extension AddExpensesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !scrollIsDone && account?.category.value != nil {
            if (account?.category.value)! > 9 {
                collectionView.contentOffset.x = collectionView.frame.width
            }
            let pageNumber = round(collectionView.contentOffset.x / collectionView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
            scrollIsDone = true
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? ExpenseCell
        
        category = selectedCell?.tag
        isSelectedCategory = true
    }
}

extension AddExpensesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.size.width / 5
        let cellHeight = collectionView.frame.size.height / 2
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

// MARK: - PickerView protocol
extension AddExpensesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
}

extension AddExpensesViewController: UIPickerViewDelegate {
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
extension AddExpensesViewController: AddAccountViewControllerDelegate {
    func inputAmount(_ sender: UIButton) {
        if let label = sender.titleLabel?.text {
            do {
//                if amountButton.titleLabel?.text == "0" && (label == "0" || label == "00") {return}
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
extension AddExpensesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            return true
        } else {
            return false
        }
    }
}
