//
//  TableViewCell.swift
//  WeatherDemo
//
//  Created by Panyushenko on 17.04.2018.
//  Copyright © 2018 Artyom Panyushenko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateAndTimeLable: UILabel!
    @IBOutlet weak var iconeWeatherImage: UIImageView!
    @IBOutlet weak var temperatureForFivesDaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
