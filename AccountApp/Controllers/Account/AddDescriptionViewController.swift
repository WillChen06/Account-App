//
//  AddDescriptionViewController.swift
//  AccountApp
//
//  Created by William Chen on 2018/1/3.
//  Copyright © 2018年 william. All rights reserved.
//

import UIKit

class AddDescriptionViewController: UIViewController {
    
    // MARK: - Properties
    lazy var describleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.textFieldBoardGrey.cgColor
        textView.layer.borderWidth = 2.0
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 20.0)
        return textView
    }()
    
    var delegate: AddAccountViewControllerDelegate?
    var inputDescription: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        describleTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupViews() {
        title = .addDescription
        view.backgroundColor = .white
        view.addSubview(describleTextView)
        if (inputDescription?.isEmpty)! {
            describleTextView.textColor = .placeholderGrey
            describleTextView.text = .addDescription
        } else {
            describleTextView.textColor = .black
            describleTextView.text = inputDescription
        }
        
        
        if #available(iOS 11.0, *) {
            describleTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        } else {
            describleTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8.0, leftConstant: 8.0, bottomConstant: 0.0, rightConstant: 8.0, widthConstant: 0.0, heightConstant: 0.0)
        }
        describleTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        describleTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.applyGradient(colors: [.brightCyan, .softBlue])
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: .cancel, style: .plain, target: self, action: #selector(dismissController))
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: .ok, style: .plain, target: self, action: #selector(saveDescription))
        ]
    }
    

    // MARK: - Action
    @objc func dismissController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @objc func saveDescription() {
        view.endEditing(true)
        delegate?.addDescription(describleTextView.text)
        dismiss(animated: true, completion: nil)
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

// MARK: - TextView Protocol
extension AddDescriptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == .addDescription {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count < 1 {
            textView.text = .addDescription
            textView.textColor = .placeholderGrey
        }
    }
}
