//
//  DailyData2TableViewCell.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 06/12/20.
//

import UIKit

class DailyData2TableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var open1Label: UILabel!
    @IBOutlet weak var low1Label: UILabel!
    @IBOutlet weak var open2Label: UILabel!
    @IBOutlet weak var low2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
