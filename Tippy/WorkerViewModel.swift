//
//  WorkerViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 7/28/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import Tipout

class WorkerViewModel: NSObject {

    // MARK: - Properties
    
    private dynamic let worker: Worker
    
    /// - note: This is used to optionaly calculate the percentage of the Worker tipout from the total tipouts
    private var totalTipouts: Double?
    
   dynamic var name: String {
        get {
            return worker.id
        }
    }
    
    dynamic var amount: String {
        get {
                var formattedAmount = String(format: "%g", worker.tipout)
                
                if formattedAmount.characters.count == 3 {
                    formattedAmount = String(format: "%#.3g", worker.tipout)
                }
                return formattedAmount
        }
    }
    
    dynamic var hours: String {
        get {
            if case .Hourly(let hours) = worker.method {
                return String(format:"%g", hours)

            } else {
                return ""
            }
        }
    }
    
    dynamic var percentage: String {
        get {
            if case .Percentage(let percentage) = worker.method {
                return "\(percentage)"
            } else if let totalTipouts = totalTipouts {
                return "(\((worker.tipout / totalTipouts) * 100))"
            } else {
                return ""
            }
        }
    }
    
    var method: (method: String, value: String) {
        get {
            switch worker.method {
            case .Amount(let amount):
                return (method: "amount", value: "\(amount)")
            case .Hourly(let hours):
                return (method: "hourly", value: "\(hours)")
            case .Percentage(let percentage):
                return (method: "percentage", value: "\(percentage)")
            default:
                return (method:"", value: "")
            }
        }
    }

    // MARK: - Initializers
    
    init(worker: Worker, totalTipouts: Double? = nil) {
        self.worker = worker
        self.totalTipouts = totalTipouts
    }
    
    init(name: String, method: String, value: String) {
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
        worker = Worker(method: tipoutMethod, id: name)
    }
    
    convenience override init() {
        self.init(name: "", method: "", value: "")
    }
    
    // MARK: = KVO
    
    class func keyPathsForValuesAffectingName() -> Set<NSObject> {
        return Set(["worker.id"])
    }
    
    class func keyPathsForValuesAffectingAmount() -> Set<NSObject> {
        return Set(["worker.tipout"])
    }

    class func keyPathsForValuesAffectingTotalText() -> Set<NSObject> {
        return Set(["tipoutModel.total"])
    }
}

extension WorkerViewModel: CustomReflectable {
    func customMirror() -> Mirror {
        return Mirror(self, children: [
            "name"      : "\(name)",
            "method"    : "\(method)",
            "amount"    : "\(amount)",
            "hours"     : "\(hours)",
            "percentage": "\(percentage)"
        ])
    }
}
