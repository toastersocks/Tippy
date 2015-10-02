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
    
    private dynamic var worker: Worker
    
    /// - note: This is used to optionaly calculate the percentage of the Worker tipout from the total tipouts
    private var totalTipouts: Double?
    
    dynamic var name: String {
        get {
            return worker.id
        }
        set {
            worker = Worker(method: worker.method, id: newValue)
        }
    }
    // TODO: Use localized number formatters for these to show properly formatted (and localized) strings
    dynamic var amount: String {
        get {
            var formattedAmount = String(format: "%.2f", worker.tipout)
            
            if formattedAmount.hasSuffix(".00") {
                formattedAmount = String(format: "%.f", worker.tipout)
            }
            return worker.tipout == 0.0 ? "" : formattedAmount
        }
        set {
            worker = Worker(method: .Amount((newValue as NSString).doubleValue), id: worker.id)
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
        set {
            if !(newValue.hasSuffix(".")) && !(newValue.isEmpty) {
                worker = Worker(method: .Hourly((newValue as NSString).doubleValue), id: worker.id)
            }
        }
    }
    
    dynamic var percentage: String {
        get {
            if case .Percentage(let percentage) = worker.method {
                return "\(percentage)"
            } else if let totalTipouts = totalTipouts {
                let percentage = (worker.tipout / totalTipouts) * 100
                var percentageString = String(format: "(%g)", percentage)
                if (percentageString as NSString).pathExtension.characters.count > 2 {
                    percentageString = String(format: "(%#.4g)", percentage)
                }
                return isnan(percentage) || percentageString == "(0)" ? "" : percentageString
            } else {
                return ""
            }
        }
        set {
            worker = Worker(method: .Percentage((newValue as NSString).doubleValue), id: worker.id)
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
        set {
            let tipoutMethod = WorkerViewModel.tipoutMethodFrom(newValue)
            worker = Worker(method: tipoutMethod, id: worker.id)
        }
    }
    
    class internal func tipoutMethodFrom(method method: String, value: String) -> TipoutMethod {
        let tipoutMethod: TipoutMethod
        let value = (value as NSString).doubleValue
        // TODO: Make these magic strings into enums
        switch method {
        case "hours", "Hours", "hourly", "Hourly":
            tipoutMethod = .Hourly(value)
        case "percentage", "Percentage":
            tipoutMethod = .Percentage(value)
        case "amount", "Amount":
            tipoutMethod = .Amount(value)
        default:
            fatalError("\(method) is not a valid method string")
        }
        return tipoutMethod
    }
    
    // MARK: - Initializers
    
    init(worker: Worker, totalTipouts: Double? = nil) {
        self.worker = worker
        self.totalTipouts = totalTipouts
    }
    
    init(name: String, method: String, value: String) {
        let tipoutMethod = WorkerViewModel.tipoutMethodFrom(method: method, value: value)
        worker = Worker(method: tipoutMethod, id: name)
    }
    
    convenience override init() {
        self.init(name: "", method: "", value: "")
    }
    
    // MARK: = KVO
    
    class func keyPathsForValuesAffectingName() -> Set<NSObject> {
        return Set(["worker", "worker.id"])
    }
    
    class func keyPathsForValuesAffectingAmount() -> Set<NSObject> {
        return Set(["worker", "worker.tipout"])
    }
    
    class func keyPathsForValuesAffectingHours() -> Set<NSObject> {
        return Set(["worker", "worker.method"])
    }
    
    class func keyPathsForValuesAffectingPercentage() -> Set<NSObject> {
        return Set(["worker", "worker.tipout", "worker.method", "totalTipouts"])
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

extension WorkerViewModel {
    override var hashValue: Int {
        return worker.hashValue
    }
    override var hash: Int {
        return hashValue
    }
    
    func isEqualToWorkerViewModel(object: AnyObject?) -> Bool {
        return isEqual(object)
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        guard let workerViewModel = object as? WorkerViewModel else { return false }
        return self.worker == workerViewModel.worker
    }
}