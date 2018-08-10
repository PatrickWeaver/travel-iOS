//
//  BusStopCell.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/9/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusStopCell: UITableViewCell {
    
    
    @IBOutlet weak var mtaId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
