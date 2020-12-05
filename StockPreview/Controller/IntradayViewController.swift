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
    
    let repository = Repository(apiClient: APIClient())
    var timeSeriesArray1Min: [(String, TimeSeries1Min)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "DataSymbolViewCell", bundle: nil)
        intradayTableView.register(cellNib, forCellReuseIdentifier: "dataCell")
        
        intradayTableView.delegate = self
        intradayTableView.dataSource = self
        
        // Appeareances
//        symbolButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        symbolButton.titleLabel?.numberOfLines = 0
//        symbolButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        symbolButton.layer.cornerRadius = 5
        symbolButton.layer.borderWidth = 1
        symbolButton.layer.borderColor = UIColor.darkGray.cgColor
        sortingButton.layer.cornerRadius = 5
        sortingButton.layer.borderWidth = 1
        sortingButton.layer.borderColor = UIColor.darkGray.cgColor
        
        // Checking symbol are selected or not
        firstLogin()
    }
    
    func firstLogin() {
        // Selected symbol is set
        if let stockSymbol = UserDefaults.standard.string(forKey: "StockSymbol") {
            intradayTableView.isHidden = false
            sortingButton.isHidden = false
            symbolButton.setTitle(stockSymbol, for: .normal)
            symbolButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        // Selected symbol was not set
        else {
            intradayTableView.isHidden = true
            sortingButton.isHidden = true
            symbolButton.setTitle("Input", for: .normal)
            symbolButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
        
    }
    
    func getIntradayData(symbol: String) {
        repository.getIntradayData1Min(symbol: "IBM"){ result in
            switch result {
            case .success(let items):

                for (key, value) in items.timeSeries1Min {
                    self.timeSeriesArray1Min.append((key,value))
                }

                // Update tableview from main thread
                DispatchQueue.main.async {
                    self.intradayTableView.reloadData()
                }

            case .failure(let error):
                print("get error intraday data: \(error)")
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
        
    }
}

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("IntradayHeaderTableViewCell", owner: self, options: nil)?.first as! IntradayHeaderTableViewCell
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSeriesArray1Min.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataSymbolTableViewCell
        let (key, value) = timeSeriesArray1Min[indexPath.row]
        cell.timeLabel.text = key
        cell.openLabel.text = value.the1Open
        cell.highLabel.text = value.the2High
        cell.lowLabel.text = value.the3Low

        return cell
    }
}
