//
//  SettingTableViewController.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private let interval = ["1 min","5 min", "15 min", "30 min", "60 min"]
    private var choosenInterval: String?
    
    let backView = UIView()
    let pickerView = UIPickerView()
    var pickerToolBar = UIToolbar()

    @IBOutlet weak var apiKeyValueLabel: UILabel!
    @IBOutlet weak var intervalValueLabel: UILabel!
    @IBOutlet weak var outputSizeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss keyboard when tap around
        self.hideKeyboardWhenTappedAround()
        
        // Make bottom of tableview into white
        tableView.tableFooterView = UIView()
        
        // Check saved data
        guard let userInterval = UserDefaults.standard.string(forKey: "User_Interval"),
              let userOutputSize = UserDefaults.standard.string(forKey: "User_OutputSize"),
              let apiKey = Keychain.shared["User_APIKey"] else { return }
        
        apiKeyValueLabel.text = apiKey
        intervalValueLabel.text = "\(userInterval) min"
        if userOutputSize == "Compact" { outputSizeSegmented.selectedSegmentIndex = 1 }
        else { outputSizeSegmented.selectedSegmentIndex = 0 }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
        
        // Setup for API Key
        if indexPath.row == 0 {
            // Creating alert
            let alert = UIAlertController(title: "Input API Key", message: "Please input your API Key.", preferredStyle: .alert)
            // Adding textfield to alert
            alert.addTextField { textField in
                textField.placeholder = "Input API Key"
            }
            
            // Creating action - oke
            let okeAction = UIAlertAction(title: "Oke", style: .default) { alertAction in
                // Getting text from textfield
                let textField = alert.textFields![0] as UITextField
                if let inputText = textField.text {
                    // Save API Key
                    Keychain.shared["User_APIKey"] = inputText
                    if let value = Keychain.shared["User_APIKey"] {
                        print(value)
                    }
                }
            }
            // Creating action - cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
            }
            
            // Adding action to textfield
            alert.addAction(okeAction)
            alert.addAction(cancelAction)
            
            // Present alert
            self.present(alert, animated: true, completion: nil)
        }
        
        // Setup for Interval
        else if indexPath.row == 1 {
            // Setup background for pickerview
            backView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            backView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.addSubview(backView)
            
            // Setup pickerview
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.backgroundColor = .white
            pickerView.contentMode = .center
            pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 430, width: UIScreen.main.bounds.size.width, height: 300)
            
            guard let userInterval = UserDefaults.standard.string(forKey: "User_Interval") else { return }
            if let row = interval.lastIndex(of: choosenInterval ?? "\(userInterval) min") {
                    pickerView.selectRow(row, inComponent: 0, animated: false)
            }
            
            self.view.addSubview(pickerView)
            
            // Setup toolbar for pickerview
            pickerToolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 430, width: UIScreen.main.bounds.size.width, height: 45))
            pickerToolBar.barStyle = .default
            pickerToolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDonePickerButtonTapped))]
            self.view.addSubview(pickerToolBar)
        }
    }
    
    @IBAction func tapOutputSizeSegmented(_ sender: UISegmentedControl) {
        switch outputSizeSegmented.selectedSegmentIndex {
        case 0:
            print("full")
            UserDefaults.standard.set("Full", forKey: "User_OutputSize")
        case 1:
            print("compact")
            UserDefaults.standard.set("Compact", forKey: "User_OutputSize")
        default:
            break
        }
    }
    
    @objc func onDonePickerButtonTapped() {
        // Remove pickerview
        backView.removeFromSuperview()
        pickerView.removeFromSuperview()
        pickerToolBar.removeFromSuperview()
        
        // Save choosen interval
        guard let choosen = choosenInterval else { return }
        intervalValueLabel.text = choosen
        UserDefaults.standard.set("\(choosen.split(separator: " ")[0])", forKey: "User_Interval")
    }
}

extension SettingTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interval.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interval[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosenInterval = interval[row]
    }
    
}
