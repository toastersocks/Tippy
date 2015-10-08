//
//  ColorDelegate.swift
//  Tippy
//
//  Created by James Pamplona on 10/7/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import Chameleon

class ColorDelegate: ColorStackViewColorDelegate {

    func colorForIndex(var index: Int) -> UIColor {
        
        let colors:[UIColor] = [
            UIColor(hexString: "E35F55"),
            UIColor(hexString: "E39955"),
            UIColor(hexString: "36818B"),
            UIColor(hexString: "41AE54")
            ]
    
        let colorSchemes = colors.map {
            color -> [UIColor] in
            guard let scheme = NSArray(ofColorsWithColorScheme: .Triadic, usingColor: color, withFlatScheme: false) as? Array<UIColor> else { fatalError("Couldn't convert array") }
            return scheme
        }
        let sequence = [2, 1, 3]
        index = index % (colorSchemes.count * sequence.count)
        let y: Int = index / colorSchemes.count
        let x = abs(colorSchemes.count * y - index)
        let color = colorSchemes[x][sequence[y]]
        return color
    }
}