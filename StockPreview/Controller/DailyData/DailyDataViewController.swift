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
    var dailyDataCount = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "DailyData1TableViewCell", bundle: nil)
        dailyDataTableView.register(cellNib, forCellReuseIdentifier: "dailyData1Cell")
        
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
        // Detect increasing number
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
                // Getting text from textfield
                let textField = alert.textFields![0] as UITextField
                if let inputText = textField.text {
                    print(inputText)
                }
                
                // Confirm adding symbol
                self.dailyDataCount = Int(sender.value)
                print(Int(sender.value))
                self.conditionOfAddingSymbol()
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
        // Detect decreasing number
        else {
            // Creating alert
            let alert = UIAlertController(title: "Delete confirmation", message: "Are you sure want to decrease the total of symbol data?", preferredStyle: .alert)
            
            // Creating action - yes
            let okeAction = UIAlertAction(title: "Yes", style: .default) { alertAction in
                self.dailyDataCount = Int(sender.value)
                self.conditionOfAddingSymbol()
                print(Int(sender.value))
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
    
    func conditionOfAddingSymbol() {
        switch dailyDataCount {
        case 0:
            symbol1Label.isHidden = true
            symbol2Label.isHidden = true
            symbol3Label.isHidden = true
            setupEmptyState()
            dailyDataTableView.isHidden = true
            titleTableLabel.isHidden = true
        case 1:
            symbol1Label.isHidden = false
            symbol2Label.isHidden = true
            symbol3Label.isHidden = true
            
            dailyDataTableView.isHidden = false
            titleTableLabel.isHidden = false
            if let label = emptyStateLabel{
                label.removeFromSuperview()
            }
            
        case 2:
            symbol1Label.isHidden = false
            symbol2Label.isHidden = false
            symbol3Label.isHidden = true
        case 3:
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
        repository.getDailyData(symbol: symbol) { result in
            switch result {
            case .success(let items):
                
                // Store new format dict data
                for (key, value) in items.timeSeriesDaily {
                    guard let date = self.dateFormatterGet.date(from: key) else { return }
                    self.dailyDataDict.updateValue(value, forKey: date)
                }
                
                // Dictionary to Array
                for (key, value) in self.dailyDataDict {
                    self.dailyDataArray.append((key,value))
                }

                // Update tableview from main thread
                DispatchQueue.main.async {
                    self.dailyDataTableView.reloadData()
                }
            case .failure(let error):
                print("get error daily data: \(error)")
            }
        }
    }
}

extension DailyDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyDataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("DailyData1HeaderTableViewCell", owner: self, options: nil)?.first as! DailyData1HeaderTableViewCell
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyData1Cell") as! DailyData1TableViewCell
        let (key, value) = dailyDataArray[indexPath.row]
        
        cell.dateLabel.text = dateFormatterPrint.string(from: key)
        cell.open1Label.text = value.the1Open
        cell.low1Label.text = value.the3Low
        
        return cell
    }
    
    
}
