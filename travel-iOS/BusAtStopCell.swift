//
//  BusAtStopCell.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/10/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusAtStopCell: UITableViewCell {

    @IBOutlet weak var arrivalProximityText: UILabel!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var metersAway: UILabel!
    @IBOutlet weak var stopsAway: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
