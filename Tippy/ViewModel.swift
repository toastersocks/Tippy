//
//  ViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import Foundation

class ViewModel: NSObject {
    
    private let tipOutModel = TipoutModel()
    
   dynamic var totalText: String {
        get {
            return "\(tipOutModel.total)"
        }
        set {
            tipOutModel.total = NSString(string: newValue).doubleValue
        }
    }
    
   dynamic var kitchenTipoutText: String {
        return "\(tipOutModel.kitchenTipout)"
    }
    
   dynamic var workersHours: [String] {
        get {
        return tipOutModel.workersHours.map {"\($0)"}
        }
        set {
            tipOutModel.workersHours =
                newValue.map { NSString(string: $0).doubleValue }
        }
    }
    
   dynamic var workersTipouts: [String] {
        return tipOutModel.workersTipOuts.map { "\($0)" }
    }
    
    
}