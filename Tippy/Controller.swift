//
//  Controller.swift
//  Tippy
//
//  Created by James Pamplona on 7/8/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Tipout
import SwiftyUserDefaults

class Controller: NSObject, ColorStackViewDelegate {
    
    // MARK: Properties
    
    fileprivate var tipoutModels = [TipoutModel]()
    
    dynamic var currentViewModel: TipoutViewModelType {
        return tipoutViewModels[currentIndex]
//        return TipoutViewModel(tipoutModel: tipoutModels[currentIndex], formatter: numberFormatter)
    }
    
    dynamic var tipoutViewModels: [TipoutViewModelType] {
        return tipoutModels.lazy.map {
            return TipoutViewModel(tipoutModel: $0, formatter: numberFormatter)
        }
    }
    
    dynamic var count: Int { return tipoutModels.count }
    fileprivate(set) dynamic var currentIndex = 0
    dynamic var numberFormatter: Formatter?
    dynamic var colorStack: ColorDelegate? {
        didSet {
            tipoutModels.forEach { _ in
                colorStack?.addColor()
            }
        }
    }
    
    var roundToNearest: Double {
        return Defaults[.roundToNearest]
    }
    
    dynamic var currentColor: UIColor {
        return colorStack?.colorForIndex(currentIndex) ?? UIColor.clear
    }
    
    // MARK: Methods
    
    func viewModel(forIndex index: Int) -> TipoutViewModelType {
        return TipoutViewModel(tipoutModel: tipoutModels[index], formatter: numberFormatter)
    }
    
    func removeCurrent() {
        tipoutModels.remove(at: currentIndex)
        colorStack?.removeColorAtIndex(currentIndex)
        if count > 0 {
            if currentIndex > 0 {
                currentIndex -= 1
            } else if currentIndex == 0 {
                // Trigger KVO notification for observers
                willChangeValue(forKey: "currentIndex")
                didChangeValue(forKey: "currentIndex")
            }
        } else if count == 0 {
            appendTipout(TipoutModel(roundToNearest: roundToNearest))
            currentIndex = 0
        }
    }
    
    func remove(atIndex index: Int) {
        tipoutModels.remove(at: currentIndex)
        colorStack?.removeColorAtIndex(currentIndex)
        if count > 0 {
            if currentIndex > count - 1 {
                currentIndex -= 1
            } else if currentIndex == 0 {
                willChangeValue(forKey: "currentIndex")
                didChangeValue(forKey: "currentIndex")
            }
        } else if count == 0 {
            // do nothing?
        }
    }
    
    func split(by splitType: Split) {
        let newTipoutTotal: Double
        
        switch splitType {
            
        case .amount(let amount):
            newTipoutTotal = amount
        case .percentage(let percentage):
            let unroundedSplit = tipoutModels[currentIndex].total * percentage
            let roundedSplit = round(unroundedSplit, toNearest: roundToNearest)
            newTipoutTotal = roundedSplit
        }
        
        tipoutModels[currentIndex].total -= newTipoutTotal
        let newTipoutModel = TipoutModel(roundToNearest: roundToNearest)
        newTipoutModel.total = newTipoutTotal
        insertTipout(newTipoutModel, atIndex: currentIndex + 1)
    }
    
    func removeAll() {
        tipoutModels.removeAll()
        colorStack?.colors.removeAll()
        appendTipout(TipoutModel(roundToNearest: roundToNearest))
        currentIndex = 0
    }
    
    func new() {
        let newTipout = TipoutModel(roundToNearest: roundToNearest)
        appendTipout(newTipout)
        currentIndex = tipoutModels.count - 1
    }
    
    func appendTipout(_ tipout: TipoutModel) {
        // TODO: defer to insertTipout: atIndex: for this
        tipoutModels.append(tipout)
        colorStack?.addColor()
    }
    
    func insertTipout(_ tipout: TipoutModel, atIndex index: Int) {
        willChangeValue(forKey: "currentViewModel")
        tipoutModels.insert(tipout, at: index)
        colorStack?.insertColorAtIndex(index)
        didChangeValue(forKey: "currentViewModel")
    }
    
    func selectViewModel(_ index: Int) {
        precondition(index < tipoutModels.count, "Index (\(index)) is out of range. tipoutModel count is \(tipoutModels.count)")
        currentIndex = index
    }
    
    func combinedTipoutsViewModel() -> TipoutViewModelType {
        let tipoutModel = tipoutModels.reduce(+) ?? TipoutModel(roundToNearest: roundToNearest)
        return TipoutViewModel(tipoutModel: tipoutModel, formatter: numberFormatter)
    }
    

    // MARK: - Initializers
    
    func setup() {
        guard let defaultsPrefsFile = Bundle.main.url(forResource: "DefaultPreferences", withExtension: "plist"),
            let defaultsPrefs = NSDictionary(contentsOf: defaultsPrefsFile) as? Dictionary<String, AnyObject>
            else { fatalError("Error loading DefaultPreferences.plist") }
        
        UserDefaults.standard.register(defaults: defaultsPrefs)
        Defaults.rac_channelTerminal(forKey: DefaultsKeys.roundToNearest._key).subscribeNextAs {
            (roundToNearest: Double) -> () in
            self.tipoutModels = self.tipoutModels.map {
                let model = TipoutModel(roundToNearest: roundToNearest)
                model.total = $0.total
                model.workers = $0.workers
                return model
            }
        }
    }
    
    init(tipoutModel: TipoutModel, numberFormatter formatter: Formatter?) {
        super.init()
        setup()
        self.numberFormatter = formatter
        self.tipoutModels.append(tipoutModel)
        currentIndex = 0
        
    }
    
    convenience init(numberFormatter formatter: Formatter? = nil) {
        self.init(tipoutModel: TipoutModel(roundToNearest: Defaults[.roundToNearest]), numberFormatter: formatter)
    }
    
    convenience init(tipoutViewModel: TipoutViewModelType, numberFormatter formatter: Formatter?) {
        guard let tipoutViewModel = tipoutViewModel as? TipoutViewModel
            else { self.init(tipoutModel: TipoutModel(), numberFormatter: formatter); return }
        self.init(tipoutModel: tipoutViewModel.tipoutModel, numberFormatter: formatter)
    }
    
    // MARK: KVO
    class func keyPathsForValuesAffectingCurrentViewModel() -> Set<NSObject> {
        return Set(["currentIndex" as NSObject, "tipoutModels" as NSObject])
    }
    
}

// MARK: - ColorStackViewDelegate
extension Controller {
    
    func colorStackViewController(_ colorStackViewController: ColorStackViewController, didSelectIndex index: Int) {
        currentIndex = index
    }
    

    func numberOfItemsInColorStackView(_ colorStackView: ColorStackViewController) -> Int {
        return count
    }
    
    func colorStackViewController(_ colorStackViewController: ColorStackViewController, shouldSelectIndex index: Int) -> Bool {
        return true
    }
    
    func currentIndexOfColorStackView(_ colorStackViewController: ColorStackViewController) -> Int {
        return currentIndex
    }
    
    // MARK: KVO
    
    class func keyPathsForValuesAffectingCurrentColor() -> Set<NSObject> {
        return Set(["currentIndex" as NSObject, "tipoutModels" as NSObject, "colorStack" as NSObject])
    }
}
