//
//  ChartViewController.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/02/12.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupNavigation() {
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
