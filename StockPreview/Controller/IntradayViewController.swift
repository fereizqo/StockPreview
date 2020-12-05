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
