//
//  forecastDayCell.swift
//  GoodStarSunny
//
//  Created by HellöM on 2020/7/20.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

class ForecastDayCell: UITableViewCell {

    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
