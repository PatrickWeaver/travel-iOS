//
//  stopsAwayBusAtStopCell.swift
//  travel-iOS
//
//  Created by PW on 8/27/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class stopsAwayBusAtStopCell: UITableViewCell {

    @IBOutlet weak var stopsAway: UILabel!
    
    @IBOutlet weak var estimatedArrival: UILabel!
    
    @IBOutlet weak var arrivalProximityText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
