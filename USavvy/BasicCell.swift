//
//  BasicCell.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/6/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
