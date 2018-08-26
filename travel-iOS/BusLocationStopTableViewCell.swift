//
//  BusLocationStopTableViewCell.swift
//  travel-iOS
//
//  Created by PW on 8/26/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusLocationStopTableViewCell: UITableViewCell {

    @IBOutlet weak var routes: UILabel!
    @IBOutlet weak var intersection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
