//
//  TipoutCell.swift
//  Tippy
//
//  Created by James Pamplona on 9/23/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class TipoutCell: UITableViewCell {

    @IBOutlet weak var tipoutIcon: UIView!
    @IBOutlet weak var totalLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
