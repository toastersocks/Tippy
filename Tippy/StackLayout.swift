//
//  StackLayout.swift
//  Tippy
//
//  Created by James Pamplona on 5/12/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

class StackLayout: UICollectionViewFlowLayout {

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { fatalError("Couldn't retrieve layout attributes for item at index path \(itemIndexPath)") }
        attributes.size.width = 0
        
        return attributes
    }
    
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { fatalError("Couldn't retrieve layout attributes for item at index path \(itemIndexPath)") }
        attributes.size.width = 0
        
        return attributes
    }
    
}
