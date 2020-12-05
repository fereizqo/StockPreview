//
//  IntradayViewController.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import UIKit

class IntradayViewController: UIViewController {

    @IBOutlet weak var symbolSearchBar: UISearchBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var intradayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register xib cell
        let cellNib = UINib(nibName: "DataSymbolViewCell", bundle: nil)
        intradayTableView.register(cellNib, forCellReuseIdentifier: "dataCell")
        
        intradayTableView.delegate = self
        intradayTableView.dataSource = self
    }
    
}

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataSymbolTableViewCell

        return cell
    }
}
