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
    
    private let repository = Repository(apiClient: APIClient())
    var dailyDataArray: [(Date, TimeSeriesDaily)] = []
    var dailyDataDict: [Date: TimeSeriesDaily] = [:]
    
    let spinner = SpinnerViewController()
    
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
        
        // Get daily data request
        repository.getDailyData(symbol: "IBM") { result in
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
