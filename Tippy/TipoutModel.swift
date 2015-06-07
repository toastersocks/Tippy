//
//  TipoutModel.swift
//  Tippy
//
//  Created by James Pamplona on 5/29/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit

func round(num: Double, #toNearest: Double) ->Double {
    return round(num / 0.25) * 0.25
}

class TipoutModel: NSObject {
    

   
   dynamic var total: Double = 0.0
    
   dynamic var kitchenTipout: Double {
        return round((total * 0.3), toNearest: 0.25)
    }
    
    dynamic var workersHours = [Double]() {
        didSet {
            debugPrintln(workersHours)
        }
    }
    
    dynamic var workersTipOuts: [Double] {
        let tipouts = workersHours.map {
        return round(((self.total - self.kitchenTipout) / self.totalWorkersHours * $0), toNearest: 0.25)
        }
        debugPrintln(tipouts)
        return tipouts
    }
    
    var totalWorkersHours: Double {
        return workersHours.reduce(0, combine: {$0 + $1})
    }
    
    // MARK: - KVO
    class func keyPathsForValuesAffectingKitchenTipout() -> Set<NSObject> {
    return Set(["total"])
    }
    
    class func keyPathsForValuesAffectingTotalWorkersHours() -> Set<NSObject> {
        return Set(["workersHours"])
    }
    
    class func keyPathsForValuesAffectingWorkersTipOuts() -> Set<NSObject> {
        return Set(["workersHours", "total"])
    }
    
}
