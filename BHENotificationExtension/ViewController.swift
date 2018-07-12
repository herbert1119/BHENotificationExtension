//
//  ViewController.swift
//  BHENotificationExtension
//
//  Created by Bo Han on 7/2/18.
//  Copyright © 2018 Bo Han. All rights reserved.
//

import UIKit

struct UserDefaultsData {
    var key: String
    var value: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    enum CellName {
        static let dataCellIdentifier = "DataCell"
    }
    
    var dataList: [UserDefaultsData] = []
    let userDefaults = UserDefaults(suiteName: "group.BHE.NotificationExtension")!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellName.dataCellIdentifier)
    }
    
    func loadData() {
        guard let savedData = userDefaults.array(forKey: "SavedData") else {
            return
        }
        dataList = savedData.map { (data) -> UserDefaultsData? in
            guard let dataStr = data as? String else {
                return nil
            }
            let keyValue = dataStr.split(separator: ":")
            return UserDefaultsData(key: String(keyValue[0]), value: String(keyValue[1]))
        } as! [UserDefaultsData]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName.dataCellIdentifier, for: indexPath)
        let data = dataList[indexPath.row]
        cell.textLabel?.text = "\(data.key): \(data.value)"
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    @IBAction func keyTextFieldEditingDidEnd(_ sender: Any) {
        validateAndAddDataEntry()
    }
    
    @IBAction func valueTextFieldEditingDidEnd(_ sender: Any) {
        validateAndAddDataEntry()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(keyTextField) {
            valueTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func validateAndAddDataEntry() {
        guard let keyText = keyTextField.text,
              let valueText = valueTextField.text,
              keyText.count > 0 && valueText.count > 0
        else {
            return
        }
        
        var newDataList = userDefaults.array(forKey: "SavedData") as? [String]
        if newDataList == nil {
            newDataList = []
        }
        
        // add new entry with string format: "key:value"
        newDataList!.append("\(keyText):\(valueText)")
        userDefaults.set(newDataList!, forKey: "SavedData")
        
        // clear text fields
        keyTextField.text = ""
        valueTextField.text = ""
        
        loadData()
        tableView.reloadData()
    }
}

