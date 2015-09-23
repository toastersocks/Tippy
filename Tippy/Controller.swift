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


class Controller: NSObject, ColorStackViewDelegate {
    
    // MARK: Properties
    
    private var tipoutModels = [TipoutModel]()
    
    dynamic var currentViewModel: TipoutViewModel {
        return TipoutViewModel(tipoutModel: tipoutModels[currentIndex])
    }
    
    var count: Int { return tipoutModels.count }
    
    private(set) dynamic var currentIndex = 0
    
    // Mark: Methods
    
    init(viewModel: TipoutModel = TipoutModel(roundToNearest: 0.25)) {
        self.tipoutModels.append(viewModel)
        currentIndex = 0
        super.init()
    }
    
    func storeCurrent() {
        let newTipout = TipoutModel(roundToNearest: 0.25)
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
    
    // MARK: - ColorStackViewDelegate
    
    @available(iOS 9.0, *)
    func colorStackView(colorStackView: ColorStackView, didSelectIndex index: Int) {
        currentIndex = index
    }
    
    @available(iOS 9.0, *)
    func numberOfItemsInColorStackView(colorStackView: ColorStackView) -> Int {
        return count
    }
    
    // MARK: - KVO
    
    class func keyPathsForValuesAffectingCurrentViewModel() -> Set<NSObject> {
        return Set(["currentIndex"])
    }
    
    /*func workerViewModelAtIndex(index: Int) -> WorkerViewModel {
    return currentViewModel.viewModelForWorkerAtIndex(index)
    }*/
    
}

/*extension Controller {
var addWorkerCommand: RACCommand {
return RACCommand(signalBlock: { (input) -> RACSignal! in

})
}
}
*/

