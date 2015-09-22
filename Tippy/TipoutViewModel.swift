//
//  TipoutViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 9/11/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import Tipout

class TipoutViewModel: NSObject {
    var tipoutModel = TipoutModel(roundToNearest: 0.25)
    
    dynamic var count: Int {
        return tipoutModel.tipouts.count
    }
    
    dynamic var totalText: String {
        get {
            return "\(tipoutModel.total)"
        }
        set {
            tipoutModel.total = NSString(string: newValue).doubleValue
        }
    }

    func addWorkerWithName(name: String, method: String, value: String, atIndex index: Int) {
        
        let tipoutMethod: TipoutMethod
        let value = (value as NSString).doubleValue
        // TODO: Make these magic strings into enums
        switch method {
        case "hours":
            fallthrough
        case "Hours":
            tipoutMethod = .Hourly(value)
        case "percentage":
            fallthrough
        case "Percentage":
            tipoutMethod = .Percentage(value)
        case "amount":
            fallthrough
        case "Amount":
            tipoutMethod = .Amount(value)
        default:
            tipoutMethod = .Amount(0.0)
        }
        
        let worker = Worker(method: tipoutMethod, id: name)
        
        if index < tipoutModel.workers.count {
            tipoutModel.workers[index] = worker
        } else if index == tipoutModel.workers.count {
        tipoutModel.workers.append(worker)
        }
    }
    
    internal dynamic var workerViewModels: [WorkerViewModel] {
        return tipoutModel.workers.map {
            return WorkerViewModel(worker: $0, totalTipouts: tipoutModel.total)
        }
    }
    
    
    init(tipoutModel: TipoutModel) {
        self.tipoutModel = tipoutModel
    }
    
    // MARK: - KVO
    
    class func keyPathsForValuesAffectingTotalText() -> Set<NSObject> {
        return Set(["tipoutModel.total"])
    }
    class func keyPathsForValuesAffectingCount() -> Set<NSObject> {
        return Set(["tipoutModel.tipouts.count"])
    }

}

extension TipoutViewModel {
    func viewModelForWorkerAtIndex(index: Int) -> WorkerViewModel {
        let worker = tipoutModel.workers[index]
        return WorkerViewModel(worker: worker, totalTipouts: tipoutModel.total)
    }
    
    subscript(index: Int) -> WorkerViewModel {
        return viewModelForWorkerAtIndex(index)
    }
}