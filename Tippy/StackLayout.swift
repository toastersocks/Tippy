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
        guard let collectionView = collectionView else { fatalError("Can't access collection View") }
        
        let numberOfItems = collectionView.numberOfItemsInSection(0)
        attributes.size.width = 0
        attributes.size.height = collectionView.bounds.height - 10
        let width = collectionView.bounds.width / CGFloat(numberOfItems)
        attributes.frame.origin.x = width * CGFloat(itemIndexPath.item)
        
        return attributes
    }
    
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { fatalError("Couldn't retrieve layout attributes for item at index path \(itemIndexPath)") }
        attributes.size.width = 0
        
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError("Can't access collection View") }
        let attributes = UICollectionViewLayoutAttributes()
        let numberOfItems = collectionView.numberOfItemsInSection(0)
        let width = collectionView.bounds.width / CGFloat(numberOfItems)
        let xOrigin = width * CGFloat(indexPath.item)
        attributes.frame = CGRect(origin: CGPoint(x: xOrigin, y: 0),
                                  size: CGSize(width: width, height: collectionView.bounds.height - 10))
        
        return attributes
    }
}
