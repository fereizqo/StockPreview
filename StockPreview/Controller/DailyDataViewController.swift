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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "DailyData1TableViewCell", bundle: nil)
        dailyDataTableView.register(cellNib, forCellReuseIdentifier: "dailyData1Cell")
        
        dailyDataTableView.delegate = self
        dailyDataTableView.dataSource = self
    }
    
}

extension DailyDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyData1Cell") as! DailyData1TableViewCell
        
        return cell
    }
    
    
}
