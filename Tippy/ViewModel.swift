//
//  ViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Tipout

class ViewModel: NSObject {
    
    private let tipoutModel = TipoutModel(roundToNearest: 0.25)
    
    dynamic var totalText: String {
        get {
            return "\(tipoutModel.total)"
        }
        set {
            tipoutModel.total = NSString(string: newValue).doubleValue
        }
    }
    
    dynamic var kitchenTipoutSignal: RACSignal {
        return RACObserve(tipoutModel, "tipouts")
            .mapAs({ (tipouts: NSArray) -> NSString in
                    return "\(tipouts[0])"
                })
    }
    
    func setWorkersHours(hours: [String]) {
        
            let newWorkers: [TipoutMethod]

            tipoutModel.setWorkers( [TipoutMethod.Percentage(0.3)] + hours.map { TipoutMethod.Hourly(NSString(string: $0).doubleValue) } )
    }
    
    dynamic var workersTipoutsSignal: RACSignal {
        return RACObserve(tipoutModel, "tipouts")
            
            .mapAs { (tipouts: NSArray) -> NSArray in
                let workersTipouts = Array((tipouts as Array)[1 ..< tipouts.count])
                return workersTipouts.map { "\($0)" }
        }
    }
    
}