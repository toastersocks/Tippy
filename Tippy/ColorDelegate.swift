//
//  ColorDelegate.swift
//  Tippy
//
//  Created by James Pamplona on 10/7/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import Chameleon

/** 
 NOTE: Should this be made to be an 'infinite' sequence that will give you the color of any index it's asked for?
 (i.e. when asked for an index greater than the current index, add colors to itself until it can give the correct color) 
 */

class ColorDelegate: NSObject, ColorStackViewColorDelegate {

    
    var colors = [UIColor]()
    
    lazy var colorPool: Set<UIColor> = {
        
        let seedColors:[UIColor] = [
            UIColor(hexString: "E35F55"),
            UIColor(hexString: "E39955"),
            UIColor(hexString: "36818B"),
            UIColor(hexString: "41AE54")
        ]
        
        let startingColors = seedColors.flatMap {
            color -> [UIColor] in
            
            guard let scheme = NSArray(
                ofColorsWith: .triadic,
                using: color,
                withFlatScheme: false)
                as? Array<UIColor> else { fatalError("Couldn't convert array") }
            
            return scheme
        }
        
        return Set(startingColors)
    }()
    
    func colorForIndex(_ index: Int) -> UIColor {
        
        return colors[index]
    }
    
    func getRandomColor() -> UIColor {
        
        return colorPool.randomElement()
    }
    
    func addColor() {
       insertColorAtIndex(colors.count)
    }
    
    func removeColorAtIndex(_ index: Int) {
        precondition(index < colors.count, "Index outside bounds of color array")
        colors.remove(at: index)
    }
    
    func insertColorAtIndex(_ index: Int) {
        precondition(index <= colors.count, "Index outside bounds of color array")
        
        let unusedColors = colorPool.subtracting(colors)
        var newColor: UIColor
        
        if !unusedColors.isEmpty {
            newColor = unusedColors.randomElement()
        } else {
            let newColorIndex = index % colorPool.count //colors.count % colorPool.count
            newColor = colors[newColorIndex]
            while newColor == colors[index > 0 ? index - 1 : 0] || newColor == colors[index < colors.count ? index : colors.count - 1] { // We don't want two of the same color next to eachother
//                newColorIndex += 1
                newColor = colorPool.randomElement() //colors[newColorIndex]
            }
        }
        colors.insert(newColor, at: index)

//        colors.insert(getRandomColor(), atIndex: index)
    }
}
