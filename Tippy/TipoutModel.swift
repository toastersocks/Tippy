//
//  TipoutModel.swift
//  Tippy
//
//  Created by James Pamplona on 5/29/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit

func round(num: Double, #toNearest: Double) -> Double {
    return round(num / 0.25) * 0.25
}

public class TipoutModel: NSObject {
    
    
    
    public dynamic var total: Double = 0.0
    
    public dynamic var kitchenTipout: Double {
        var tipout = round((total * 0.3), toNearest: 0.25)
        tipout = total - (tipout + round(total - tipout, toNearest: 0.25)) + tipout
        return tipout
    }
    
    public dynamic var workersHours = [Double](count: 5, repeatedValue: 0.0)
    
    public dynamic var workersTipOuts: [Double] {
        
        let tipouts = workersHours.map {
            (workerHours: Double) -> Double in
            let tipout = round(((self.total - self.kitchenTipout) / self.totalWorkersHours * workerHours), toNearest: 0.25)
            // If we try to divide by zero, the result will be 'nan', 'Not a Number', so we have to check for this and return 0.0 if it is
            return isnan(tipout) ? 0.0 : tipout
        }
        return tipouts
    }
    
    public var totalWorkersHours: Double {
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
