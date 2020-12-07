//
//  IntradayViewController.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import UIKit

class IntradayViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var symbolButton: UIButton!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var intradayTableView: UITableView!
    
    private let repository = Repository(apiClient: APIClient())
    private let apiClient = APIClient()
    var timeSeriesArray: [(Date, TimeSeries)] = []
    var timeSeriesDict: [Date: TimeSeries] = [:]
    
    let backView = UIView()
    let pickerView = UIPickerView()
    var pickerToolBar = UIToolbar()
    let spinner = SpinnerViewController()
    var emptyStateLabel: UILabel?
    
    private let interval = ["Date ↓","Date ↑","Open ↓","Open ↑","High ↓","High ↑","Low ↓","Low ↑"]
    private var choosenInterval: String?
    
    lazy var dateFormatterGet: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
     }()
    
    lazy var dateFormatterPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm d-MM-yy"
        return formatter
     }()
    
    lazy var currentDateFormatterPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "DataSymbolViewCell", bundle: nil)
        intradayTableView.register(cellNib, forCellReuseIdentifier: "dataCell")
        
        intradayTableView.delegate = self
        intradayTableView.dataSource = self
        
        // Appeareances
        setupEmptyState()
        symbolButton.layer.cornerRadius = 5
        symbolButton.layer.borderWidth = 1
        symbolButton.layer.borderColor = UIColor.darkGray.cgColor
        sortingButton.layer.cornerRadius = 5
        sortingButton.layer.borderWidth = 1
        sortingButton.layer.borderColor = UIColor.darkGray.cgColor
        dateLabel.text = "Current Date : \(currentDateFormatterPrint.string(from: Date()))"
        
        // Checking symbol are selected or not
        firstLogin()
    }
    
    // Setup empty state
    func setupEmptyState() {
        emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        if let label = emptyStateLabel {
            label.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
            label.textAlignment = .center
            label.text = "No 'symbol' data is showed. \n Please 'input' first."
            label.numberOfLines = 0
            self.view.addSubview(label)
        }
    }
    
    // Setup appearance either symbor setted or not
    func firstLogin() {
        // Selected symbol is set
        if let stockSymbol = UserDefaults.standard.string(forKey: "StockSymbol") {
            intradayTableView.isHidden = false
            sortingButton.isHidden = false
            sortingButton.setTitle("Sort by : ", for: .normal)
            symbolButton.setTitle(stockSymbol, for: .normal)
            symbolButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            getIntradayData(symbol: stockSymbol)
            // Remove emptystate from view
            if let label = emptyStateLabel{
                label.removeFromSuperview()
            }
        }
        // Selected symbol was not set
        else {
            intradayTableView.isHidden = true
            sortingButton.isHidden = true
            symbolButton.setTitle("Input", for: .normal)
            symbolButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
        
    }
    
    // Get request for intraday data
    func getIntradayData(symbol: String) {
        // Show spinner
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        // Reset data
        timeSeriesDict.removeAll()
        timeSeriesArray.removeAll()
        
        // Do request
        repository.getIntradayData(symbol: "IBM"){ result in
            switch result {
            case .success(let items):
                
                // Store new format dict data
                for (key, value) in items.timeSeries {
                    guard let date = self.dateFormatterGet.date(from: key) else { return }
                    self.timeSeriesDict.updateValue(value, forKey: date)
                }
                
                // Dictionary to Array
                for (key, value) in self.timeSeriesDict {
                    self.timeSeriesArray.append((key,value))
                }

                // Update tableview from main thread
                DispatchQueue.main.async {
                    self.intradayTableView.reloadData()
                    
                    // Remove spinner
                    self.spinner.willMove(toParent: nil)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                }

            case .failure(let error):
                print("get error intraday data: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(alertText: "Connection Error", alertMessage: "Failed to get data. \n Error: \(error).")
                    self.intradayTableView.isHidden = true
                    
                    // Remove spinner
                    self.spinner.willMove(toParent: nil)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                }
            }
        }
    }
    
    @IBAction func symbolButtonTapped(_ sender: UIButton) {
        // Creating alert
        let alert = UIAlertController(title: "Input Stock Symbol", message: "Please input stock symbol to get it's information. \n (example: IDX)", preferredStyle: .alert)
        // Adding textfield to alert
        alert.addTextField { textField in
            textField.placeholder = "Input symbol"
            textField.autocapitalizationType = .allCharacters
        }
        
        // Creating action - oke
        let okeAction = UIAlertAction(title: "Oke", style: .default) { alertAction in
            let textField = alert.textFields![0] as UITextField
            if let inputText = textField.text {
                // Store preferences stock symbol
                UserDefaults.standard.set(inputText, forKey: "StockSymbol")
                // Set appearances
                self.firstLogin()
                // Get data
                self.getIntradayData(symbol: inputText)
            }
        }
        // Creating action - cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Adding action to textfield
        alert.addAction(okeAction)
        alert.addAction(cancelAction)
        
        // Present alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func sortingButtonTapped(_ sender: UIButton) {
        // Setup background for pickerview
        backView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        backView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(backView)
        
        // Setup pickerview
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.contentMode = .center
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(pickerView)
        
        // Setup toolbar for pickerview
        pickerToolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 35))
        pickerToolBar.barStyle = .default
        pickerToolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDonePickerButtonTapped))]
        self.view.addSubview(pickerToolBar)
    }
    
    @objc func onDonePickerButtonTapped() {
        // Remove pickerview
        backView.removeFromSuperview()
        pickerView.removeFromSuperview()
        pickerToolBar.removeFromSuperview()
        
        // Get choosen data
        if let choosenIntervals = choosenInterval {
            // Remove array data
            self.timeSeriesArray.removeAll()
            
            // Set button title
            sortingButton.setTitle("Sort by : \(choosenIntervals)", for: .normal)
            
            // Getting Selected Sorting Value
            let param = choosenIntervals.split(separator: " ")[0]
            
            // Ascending order
            if choosenIntervals.split(separator: " ")[1] == "↓" {
                if param == "Open" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the1Open < $1.value.the1Open }) {
                        self.timeSeriesArray.append((key,value))
                    }
                } else if param == "High" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the2High < $1.value.the2High }) {
                        self.timeSeriesArray.append((key,value))
                    }
                } else if param == "Low" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the3Low < $1.value.the3Low }) {
                        self.timeSeriesArray.append((key,value))
                    }
                } else if param == "Date" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.key < $1.key }) {
                        self.timeSeriesArray.append((key,value))
                    }
                }
            }
            
            // Descending order
            else if choosenIntervals.split(separator: " ")[1] == "↑" {
                if param == "Open" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the1Open > $1.value.the1Open }) {
                        self.timeSeriesArray.append((key,value))
                    }
                } else if param == "High" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the2High > $1.value.the2High }) {
                        self.timeSeriesArray.append((key,value))
                    }
                    
                } else if param == "Low" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.value.the3Low > $1.value.the3Low }) {
                        self.timeSeriesArray.append((key,value))
                    }
                } else if param == "Date" {
                    for (key, value) in self.timeSeriesDict.sorted(by: { $0.key > $1.key }) {
                        self.timeSeriesArray.append((key,value))
                    }
                }
            }
            
            // Reload tableview
            intradayTableView.reloadData()
        }
    }
}

// Tableview Delegate and Datasource
extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("IntradayHeaderTableViewCell", owner: self, options: nil)?.first as! IntradayHeaderTableViewCell
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSeriesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataSymbolTableViewCell
        let (key, value) = timeSeriesArray[indexPath.row]
        
        cell.timeLabel.text = dateFormatterPrint.string(from: key)
        cell.openLabel.text = value.the1Open
        cell.highLabel.text = value.the2High
        cell.lowLabel.text = value.the3Low

        return cell
    }
}

// Pickerview Delegate and Datasource
extension IntradayViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
