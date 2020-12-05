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
        symbolButton.layer.cornerRadius = 5
        symbolButton.layer.borderWidth = 1
        symbolButton.layer.borderColor = UIColor.darkGray.cgColor
        sortingButton.layer.cornerRadius = 5
        sortingButton.layer.borderWidth = 1
        sortingButton.layer.borderColor = UIColor.darkGray.cgColor
        
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
    
}

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
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
