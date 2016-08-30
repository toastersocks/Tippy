//
//  CollectionViewController.swift
//  ColorStackViewTest
//
//  Created by James Pamplona on 3/8/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit

private let reuseIdentifier = "colorCell"
private let footerReuseIdentifier = "footerView"

public protocol ColorStackViewDelegate {
    
    func colorStackViewController(colorStackViewController: ColorStackViewController, didSelectIndex index: Int)
    func colorStackViewController(colorStackViewController: ColorStackViewController, shouldSelectIndex index: Int) -> Bool
    func numberOfItemsInColorStackView(colorStackViewController: ColorStackViewController) -> Int
    func currentIndexOfColorStackView(colorStackViewController: ColorStackViewController) -> Int
}

@objc public protocol ColorStackViewColorDelegate {
    func colorForIndex(index:Int) -> UIColor
}

public class ColorStackViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    public var colors: [UIColor] = [.greenColor(), .redColor(), .blueColor(), .orangeColor()]
    var delegate: ColorStackViewDelegate? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var colorDelegate: ColorStackViewColorDelegate? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    weak var footerView: UICollectionReusableView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.registerClass(ColorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        flowLayout.footerReferenceSize = CGSize(width: collectionView!.bounds.width, height: 10)

        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removeItemAtIndex(index: Int) {
        
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        guard let delegate = delegate else { return }
        collectionView?.backgroundColor = colorDelegate?.colorForIndex(delegate.currentIndexOfColorStackView(self))
    }
    
    func decrement() {
        guard let delegate = delegate else { return }
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: (delegate.numberOfItemsInColorStackView(self)) - 1, inSection: 0)])
    }
    
    func insertItemAtIndex(index: Int) {
        collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    func increment() {
        guard let delegate = delegate else { return }
        let lastIndex = delegate.numberOfItemsInColorStackView(self) - 1
        insertItemAtIndex(lastIndex)
        guard let collectionView = collectionView else { fatalError("Can't access collectionView") }
        collectionView.selectItemAtIndexPath(NSIndexPath(forItem: lastIndex, inSection: 0), animated: true, scrollPosition: .None)
        self.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: lastIndex, inSection: 0))
    }
    
    func reload() {
        collectionView?.reloadData()
        guard let delegate = delegate else { return }
        collectionView?.backgroundColor = colorDelegate?.colorForIndex(delegate.currentIndexOfColorStackView(self))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfItemsInColorStackView(self)
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ColorCell
        
        cell.contentView.backgroundColor = colorDelegate?.colorForIndex(indexPath.item) ?? colors[indexPath.item % colors.count]
        cell.isAccessibilityElement = true
        return cell
    }
    
    
    override public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: footerReuseIdentifier, forIndexPath: indexPath)
        footerView = footer
        return footer
    }
    
    // MARK: UICollectionViewDelegate
    
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let delegate = delegate where delegate.colorStackViewController(self, shouldSelectIndex: indexPath.item) == true else { return }
        delegate.colorStackViewController(self, didSelectIndex: indexPath.item)
        collectionView.backgroundColor = colorDelegate?.colorForIndex(indexPath.item)
        /*let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.layer.shadowColor = UIColor.blackColor().CGColor
        cell?.layer.shadowOffset = CGSize(width: 1, height: 0)
        cell?.layer.shadowOpacity = 1
        cell?.layer.shadowRadius = 1.0
        cell?.layer.masksToBounds = false
        cell?.clipsToBounds = false
        cell?.layer.zPosition = 0*/
        
        
        
    }
    
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Tipout \(indexPath.item)"
        cell.accessibilityIdentifier = "tipout\(indexPath.item)"
    }
    
    public override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath)
//        cell?.clipsToBounds = true
//        cell?.layer.masksToBounds = true
//        cell?.layer.shadowRadius = 0.0

    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return inset
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let delegate = delegate else { return CGSizeZero}
        let size = CGSize(width: (collectionView.bounds.size.width) / CGFloat(delegate.numberOfItemsInColorStackView(self)),
            height: collectionView.bounds.size.height - 10)
        return size
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: 10, height: 10)
        return size
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    

    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
