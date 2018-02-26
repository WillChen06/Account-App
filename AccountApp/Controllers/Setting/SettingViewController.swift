//
//  SettingViewController.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/17.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit
import UserNotifications

protocol SettingViewControllerDelegate {
    func switchMode(_ sender: UISwitch)
}

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        } else {
            tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0.0, leftConstant: 0.0, bottomConstant: 0.0, rightConstant: 0.0, widthConstant: 0.0, heightConstant: 0.0)
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = .setting
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
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

// MARK: - UITableView Protocol
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            fatalError("Unknown section.")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = LocalNotificationCell()
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case 1:
            let cell = AppInfoCell()
            return cell
        case 2:
            let cell = ClearDataCell()
            return cell
        default:
            fatalError("Unknown section.")
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return .basicSetting
        case 1:
            return .info
        case 2:
            return .data
        default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
//            let notificationVC = LocalNotificationViewController()
//            navigationController?.pushViewController(notificationVC, animated: true)
            break
        case 1:
            let versionVC = VersionViewController()
            navigationController?.pushViewController(versionVC, animated: true)
        case 2:
            let alert = UIAlertController(title: .remind, message: .clearAlert, preferredStyle: .alert)
            alert.addAction(title: .ok, style: .default, handler: { (_) in
                RealmHelper.deleteAll()
            })
            alert.addAction(title: .cancel, style: .cancel, handler: nil)
            present(alert, animated: true, completion: nil)
        default:
            fatalError("Unknown section")
        }
    }
}


extension SettingViewController: SettingViewControllerDelegate {
    func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setNotificationMode(true)
            UNUserNotificationCenter.current().addDailyNotification()
            print("Change To True")
        } else {
            UserDefaults.standard.setNotificationMode(false)
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            print("Change To False")
        }
    }
}
