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


class Controller: NSObject {
   
    // MARK: Properties
    
    private var tipoutModels = [TipoutModel]()
    
    var currentViewModel: TipoutViewModel {
        return TipoutViewModel(tipoutModel: tipoutModels[currentIndex])
    }
    
    var count: Int { return tipoutModels.count }

    private(set) var currentIndex = 0

    // Mark: Methods
    
    init(viewModel: TipoutModel = TipoutModel(roundToNearest: 0.25)) {
        self.tipoutModels.append(viewModel)
        currentIndex = 0
        super.init()
    }
    
    func storeCurrent() {
        let newTipout = TipoutModel()
        tipoutModels.append(newTipout)
        currentIndex = tipoutModels.count - 1
    }
    
    func selectViewModel(index: Int) {
        if index < tipoutModels.count - 1 {
            currentIndex = index
        } else {
            fatalError("Index (\(index)) is out of range. tipoutModel count is \(tipoutModels.count)")
        }
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

