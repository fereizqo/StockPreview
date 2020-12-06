//
//  DailyDataViewController.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import UIKit

class DailyDataViewController: UIViewController {

    @IBOutlet weak var titleTableLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyDataTableView: UITableView!
    @IBOutlet weak var symbol1Label: UILabel!
    @IBOutlet weak var symbol2Label: UILabel!
    @IBOutlet weak var symbol3Label: UILabel!
    @IBOutlet weak var symbolStepper: UIStepper!
    
    private let repository = Repository(apiClient: APIClient())
    var dailyDataArray: [(Date, TimeSeriesDaily)] = []
    var dailyDataDict: [Date: TimeSeriesDaily] = [:]
    
    var dataTimeSeries1: [DataTimeSeriesDaily] = []
    var dataTimeSeries2: [DataTimeSeriesDaily] = []
    var dataTimeSeries3: [DataTimeSeriesDaily] = []
    
    var dataTimeSeriesCompare2: [TimeSeriesCompare2] = []
    var dataTimeSeriesCompare3: [TimeSeriesCompare3] = []
    
    var dailyDataCount = 0
    var dailyDataSymbolArray: [String] = []
    
    let spinner = SpinnerViewController()
    var emptyStateLabel: UILabel?
    
    lazy var dateFormatterGet: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
     }()
    
    lazy var dateFormatterPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
     }()
    
    lazy var dateFormatterShortPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        return formatter
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib1 = UINib(nibName: "DailyData1TableViewCell", bundle: nil)
        let cellNib2 = UINib(nibName: "DailyData2TableViewCell", bundle: nil)
        let cellNib3 = UINib(nibName: "DailyData3TableViewCell", bundle: nil)
        dailyDataTableView.register(cellNib1, forCellReuseIdentifier: "dailyData1Cell")
        dailyDataTableView.register(cellNib2, forCellReuseIdentifier: "dailyData2Cell")
        dailyDataTableView.register(cellNib3, forCellReuseIdentifier: "dailyData3Cell")
        
        dailyDataTableView.delegate = self
        dailyDataTableView.dataSource = self
        
        // Initial condition
        symbol1Label.isHidden = true
        symbol2Label.isHidden = true
        symbol3Label.isHidden = true
        setupEmptyState()
        dailyDataTableView.isHidden = true
        titleTableLabel.isHidden = true
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // Confirm increasing number
        if Int(sender.value) >= dailyDataCount {
            // Creating alert
            let alert = UIAlertController(title: "Input Stock Symbol", message: "Please input stock symbol to get it's information. \n (example: IDX)", preferredStyle: .alert)
            // Adding textfield to alert
            alert.addTextField { textField in
                textField.placeholder = "Input symbol"
                textField.autocapitalizationType = .allCharacters
            }
            
            // Creating action - oke
            let okeAction = UIAlertAction(title: "Oke", style: .default) { alertAction in
                // Confirm adding symbol
                self.dailyDataCount = Int(sender.value)
                self.conditionBasedOnSymbolCount()
                
                // Getting text from textfield
                let textField = alert.textFields![0] as UITextField
                if let inputText = textField.text {
                    self.dailyDataSymbolArray.append(inputText)
                    self.conditionOfAddingSymbol(symbol: inputText)
                }
            }
            // Creating action - cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
                self.symbolStepper.value = Double(self.dailyDataCount)
            }
            
            // Adding action to textfield
            alert.addAction(okeAction)
            alert.addAction(cancelAction)
            
            // Present alert
            self.present(alert, animated: true, completion: nil)
            
        }
        // Confirm decreasing number
        else {
            // Creating alert
            let alert = UIAlertController(title: "Delete confirmation", message: "Are you sure want to decrease the total of symbol data?", preferredStyle: .alert)
            
            // Creating action - yes
            let okeAction = UIAlertAction(title: "Yes", style: .default) { alertAction in
                self.dailyDataCount = Int(sender.value)
                self.conditionBasedOnSymbolCount()
                self.dailyDataSymbolArray.removeLast()
                
                // Remove array data
                self.conditionOfDecreasingSymbol()
                self.dailyDataTableView.reloadData()
            }
            // Creating action - cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
                self.symbolStepper.value = Double(self.dailyDataCount)
            }
            
            // Adding action to textfield
            alert.addAction(okeAction)
            alert.addAction(cancelAction)
            
            // Present alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Condition when adding symbol
    func conditionOfAddingSymbol(symbol: String) {
        switch dailyDataCount {
        case 1:
            symbol1Label.text = "• Data 1 : \(dailyDataSymbolArray[dailyDataCount-1])"
            getDailyData(symbol: symbol)
        case 2:
            symbol2Label.text = "• Data 2 : \(dailyDataSymbolArray[dailyDataCount-1])"
            getDailyData(symbol: symbol)
        case 3:
            symbol3Label.text = "• Data 3 : \(dailyDataSymbolArray[dailyDataCount-1])"
            getDailyData(symbol: symbol)
        default:
            print("")
        }
    }
    
    // Condition when decreasing symbol
    func conditionOfDecreasingSymbol() {
        switch dailyDataCount {
        case 0:
            dataTimeSeries1.removeAll()
        case 1:
            dataTimeSeries2.removeAll()
            dataTimeSeriesCompare2.removeAll()
        case 2:
            dataTimeSeries3.removeAll()
            dataTimeSeriesCompare3.removeAll()
        default:
            print("")
        }
    }
    
    // Condition based on Symbol Count
    func conditionBasedOnSymbolCount() {
        switch dailyDataCount {
        case 0:
            // Hidden all symbol label, table and title
            symbol1Label.isHidden = true
            symbol2Label.isHidden = true
            symbol3Label.isHidden = true
            setupEmptyState()
            dailyDataTableView.isHidden = true
            titleTableLabel.isHidden = true
        case 1:
            // Show symbol 1 label
            symbol1Label.isHidden = false
            symbol2Label.isHidden = true
            symbol3Label.isHidden = true
            
            // Show table and title label then remove emptystate label
            dailyDataTableView.isHidden = false
            titleTableLabel.isHidden = false
            if let label = emptyStateLabel{
                label.removeFromSuperview()
            }
            
        case 2:
            // Show symbol 1,2 label
            symbol1Label.isHidden = false
            symbol2Label.isHidden = false
            symbol3Label.isHidden = true
        case 3:
            // Show symbol 1,2,3 label
            symbol1Label.isHidden = false
            symbol2Label.isHidden = false
            symbol3Label.isHidden = false
        default:
            print("")
        }
    }
    
    // Setup empty state
    func setupEmptyState() {
        emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        if let label = emptyStateLabel {
            label.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
            label.textAlignment = .center
            label.text = "No 'symbol' data is showed. \n Please '+' first."
            label.numberOfLines = 0
            self.view.addSubview(label)
        }
    }
    
    // Get daily data request
    func getDailyData(symbol: String) {
        // Show spinner
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        // Reset dailydatadict
        dailyDataDict.removeAll()
        
        // Do request
        repository.getDailyData(symbol: symbol) { result in
            switch result {
            case .success(let items):
                
                // Store new format dict data
                for (key, value) in items.timeSeriesDaily {
                    guard let date = self.dateFormatterGet.date(from: key) else { return }
                    self.dailyDataDict.updateValue(value, forKey: date)
                }
                
                // Match to data count
                switch self.dailyDataCount {
                case 1:
                    // Get value for symbol 1
                    for (key, value) in self.dailyDataDict {
                        let testDaily = DataTimeSeriesDaily(date: key, open: value.the1Open, low: value.the3Low)
                        self.dataTimeSeries1.append(testDaily)
                    }
                    
                    // Sorting by date
                    self.dataTimeSeries1 = self.dataTimeSeries1.sorted{ $0.date > $1.date}
                
                case 2:
                    // Get value for symbol 2
                    for (key, value) in self.dailyDataDict {
                        let testDaily = DataTimeSeriesDaily(date: key, open: value.the1Open, low: value.the3Low)
                        self.dataTimeSeries2.append(testDaily)
                    }
                    
                    // Get value between symbol 1 and symbol 2
                    for data1 in self.dataTimeSeries1 {
                        for data2 in self.dataTimeSeries2 {
                            if data1.date == data2.date {
                                let timeSeriesCompare2 = TimeSeriesCompare2(date: data1.date, open1: data1.open, low1: data1.low, open2: data2.open, low2: data2.low)
                                self.dataTimeSeriesCompare2.append(timeSeriesCompare2)
                            }
                        }
                    }
                    
                    // Sorting by date
                    self.dataTimeSeriesCompare2 = self.dataTimeSeriesCompare2.sorted{ $0.date > $1.date}
                    
                case 3:
                    // Get value for symbol 3
                    for (key, value) in self.dailyDataDict {
                        let testDaily = DataTimeSeriesDaily(date: key, open: value.the1Open, low: value.the3Low)
                        self.dataTimeSeries3.append(testDaily)
                    }
                    
                    // Get value between symbol 12 and symbol 3
                    for data12 in self.dataTimeSeriesCompare2 {
                        for data3 in self.dataTimeSeries3 {
                            if data12.date == data3.date {
                                let timeSeriesCompare3 = TimeSeriesCompare3(date: data12.date, open1: data12.open1, low1: data12.low1, open2: data12.open2, low2: data12.low2, open3: data3.open, low3: data3.low)
                                self.dataTimeSeriesCompare3.append(timeSeriesCompare3)
                            }
                        }
                    }
                    
                    // Sorting by date
                    self.dataTimeSeriesCompare3 = self.dataTimeSeriesCompare3.sorted{ $0.date > $1.date}
                    
                default:
                    print("")
                }

                // Update tableview from main thread
                DispatchQueue.main.async {
                    self.dailyDataTableView.reloadData()
                    
                    // Remove spinner
                    self.spinner.willMove(toParent: nil)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                }
                
            case .failure(let error):
                print("get error daily data: \(error)")
                
                // Remove spinner
                self.spinner.willMove(toParent: nil)
                self.spinner.view.removeFromSuperview()
                self.spinner.removeFromParent()
            }
        }
    }
}

extension DailyDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTimeSeries1.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView1 = Bundle.main.loadNibNamed("DailyData1HeaderTableViewCell", owner: self, options: nil)?.first as! DailyData1HeaderTableViewCell
        let headerView2 = Bundle.main.loadNibNamed("DailyData2HeaderTableViewCell", owner: self, options: nil)?.first as! DailyData2HeaderTableViewCell
        let headerView3 = Bundle.main.loadNibNamed("DailyData3HeaderTableViewCell", owner: self, options: nil)?.first as! DailyData3HeaderTableViewCell
        
        switch dailyDataCount {
        case 1:
            return headerView1
        case 2:
            return headerView2
        case 3:
            return headerView3
        default:
            return headerView1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "dailyData1Cell") as! DailyData1TableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "dailyData2Cell") as! DailyData2TableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "dailyData3Cell") as! DailyData3TableViewCell
        
        switch dailyDataCount {
        case 1:
            let data1 = dataTimeSeries1[indexPath.row]
            cell1.dateLabel.text = dateFormatterPrint.string(from: data1.date)
            cell1.open1Label.text = data1.open
            cell1.low1Label.text = data1.low
            return cell1
        case 2:
            let data12 = dataTimeSeriesCompare2[indexPath.row]
            cell2.dateLabel.text = dateFormatterShortPrint.string(from: data12.date)
            cell2.open1Label.text = data12.open1
            cell2.low1Label.text = data12.low1
            cell2.open2Label.text = data12.open2
            cell2.low2Label.text = data12.low2
            return cell2
        case 3:
            let data123 = dataTimeSeriesCompare3[indexPath.row]
            cell3.dateLabel.text = dateFormatterShortPrint.string(from: data123.date)
            cell3.open1Label.text = data123.open1
            cell3.low1Label.text = data123.low1
            cell3.open2Label.text = data123.open2
            cell3.low2Label.text = data123.low2
            cell3.open3Label.text = data123.open3
            cell3.low3Label.text = data123.low3
            return cell3
        default:
            return cell1
        }
    }
    
    
}
