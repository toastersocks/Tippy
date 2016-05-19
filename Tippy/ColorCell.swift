//
//  ColorCell.swift
//  ColorStackViewTest
//
//  Created by James Pamplona on 3/8/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable var color: UIColor = UIColor.clearColor()
    
}
