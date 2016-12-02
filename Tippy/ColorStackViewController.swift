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
    
    func colorStackViewController(_ colorStackViewController: ColorStackViewController, didSelectIndex index: Int)
    func colorStackViewController(_ colorStackViewController: ColorStackViewController, shouldSelectIndex index: Int) -> Bool
    func numberOfItemsInColorStackView(_ colorStackViewController: ColorStackViewController) -> Int
    func currentIndexOfColorStackView(_ colorStackViewController: ColorStackViewController) -> Int
}

@objc public protocol ColorStackViewColorDelegate {
    func colorForIndex(_ index:Int) -> UIColor
}

open class ColorStackViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    open var colors: [UIColor] = [.green, .red, .blue, .orange]
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
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.register(ColorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        flowLayout.footerReferenceSize = CGSize(width: collectionView!.bounds.width, height: 10)

        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removeItemAtIndex(_ index: Int) {
        
        collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        guard let delegate = delegate else { return }
        collectionView?.backgroundColor = colorDelegate?.colorForIndex(delegate.currentIndexOfColorStackView(self))
    }
    
    func decrement() {
        guard let delegate = delegate else { return }
        collectionView?.deleteItems(at: [IndexPath(item: (delegate.numberOfItemsInColorStackView(self)) - 1, section: 0)])
    }
    
    func insertItemAtIndex(_ index: Int) {
        collectionView?.insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func increment() {
        guard let delegate = delegate else { return }
        let lastIndex = delegate.numberOfItemsInColorStackView(self) - 1
        insertItemAtIndex(lastIndex)
        guard let collectionView = collectionView else { fatalError("Can't access collectionView") }
        collectionView.selectItem(at: IndexPath(item: lastIndex, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition())
        self.collectionView(collectionView, didSelectItemAt: IndexPath(item: lastIndex, section: 0))
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
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfItemsInColorStackView(self)
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCell
        
        cell.contentView.backgroundColor = colorDelegate?.colorForIndex(indexPath.item) ?? colors[indexPath.item % colors.count]
        cell.isAccessibilityElement = true
        return cell
    }
    
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
        footerView = footer
        return footer
    }
    
    // MARK: UICollectionViewDelegate
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = delegate, delegate.colorStackViewController(self, shouldSelectIndex: indexPath.item) == true else { return }
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
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Tipout \(indexPath.item)"
        cell.accessibilityIdentifier = "tipout\(indexPath.item)"
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath)
//        cell?.clipsToBounds = true
//        cell?.layer.masksToBounds = true
//        cell?.layer.shadowRadius = 0.0

    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return inset
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let delegate = delegate else { return CGSize.zero}
        let size = CGSize(width: (collectionView.bounds.size.width) / CGFloat(delegate.numberOfItemsInColorStackView(self)),
            height: collectionView.bounds.size.height - 10)
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: 10, height: 10)
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
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
