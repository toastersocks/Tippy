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
    
    private var tipoutModels = [TipoutModel]()
    
    dynamic var currentViewModel: TipoutViewModelType {
        return TipoutViewModel(tipoutModel: tipoutModels[currentIndex], formatter: numberFormatter)
    }
    
    var count: Int { return tipoutModels.count }
    private(set) dynamic var currentIndex = 0
    var numberFormatter: Formatter?
    
    // MARK: Methods
    
    func storeCurrent() {
        let newTipout = TipoutModel(roundToNearest: Defaults[.roundToNearest])
        tipoutModels.append(newTipout)
        currentIndex = tipoutModels.count - 1
    }
    
    func selectViewModel(index: Int) {
        if index < tipoutModels.count {
            currentIndex = index
        } else {
            fatalError("Index (\(index)) is out of range. tipoutModel count is \(tipoutModels.count)")
        }
    }
    
    func combinedTipoutsViewModel() -> TipoutViewModelType? {
        guard let tipoutModel = tipoutModels.reduce(+) else { return nil }
        return TipoutViewModel(tipoutModel: tipoutModel, formatter: numberFormatter)
    }
    
    // MARK: - Initializers
    
    func setup() {
        Defaults.rac_channelTerminalForKey("roundToNearest").subscribeNextAs {
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
    
    // MARK: - ColorStackViewDelegate
    

    func colorStackView(colorStackView: ColorStackView, didSelectIndex index: Int) {
        currentIndex = index
    }
    

    func numberOfItemsInColorStackView(colorStackView: ColorStackView) -> Int {
        return count
    }
    
    func colorStackView(colorStackView: ColorStackView, shouldSelectIndex index: Int) -> Bool {
        return true
    }
    
    func currentIndexOfColorStackView(colorStackView: ColorStackView) -> Int {
        return currentIndex
    }
    // MARK: - KVO
    
    class func keyPathsForValuesAffectingCurrentViewModel() -> Set<NSObject> {
        return Set(["currentIndex", "tipoutModels"])
    }
}
