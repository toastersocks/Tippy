//
//  WorkerViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 7/28/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
import Tipout
import SwiftyUserDefaults

/*enum SymbolPosition {
    case Beginning(symbol: String)
    case End(symbol: String)
    case Other
}*/
@objc enum SymbolPosition: Int {
    case Beginning
    case End
    case Other
}

final class WorkerViewModel: NSObject, WorkerViewModelType {
    
    // MARK: - Properties
    
    var currencySymbolPosition: SymbolPosition {
        guard let formatter = formatter else { return .Other }
        
        switch formatter.currencySymbolPosition {
        case .Beginning:
            return .Beginning
        case .End:
            return .End
        }
    }
    
    var percentSymbolPosition: SymbolPosition {
        guard let formatter = formatter else { return .Other }
        
        switch formatter.percentSymbolPosition {
        case .Beginning:
            return .Beginning
        case .End:
            return .End
        }
    }
    
    var percentSymbol: String {
        return formatter?.percentSymbol ?? ""
    }
    
    var currencySymbol: String {
        return formatter?.currencySymbol ?? ""
    }
    
    dynamic var worker: Worker
    private let formatter: Formatter?
    
    /// - note: This is used to optionally calculate the percentage of the Worker tipout from the total tipouts
    private var totalTipouts: Double?
    
    dynamic var name: String {
        get {
            return worker.id
        }
        set {
            worker = Worker(method: worker.method, id: newValue)
        }
    }
    
    dynamic var amount: String {
        get {
            if let formatter = formatter,
                currencyString = try? formatter.currencyStringFromNumber(worker.tipout) {
            return currencyString
            } else { return "" }
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
    
    dynamic var percentage: NSAttributedString {
        get {
            if case .Percentage(let percentage) = worker.method {
                    let percentageString = (try? formatter?.percentageStringFromNumber(percentage)).flatMap { $0 } ?? "\(percentage)"
                return NSAttributedString(string: percentageString,
                    attributes: [NSForegroundColorAttributeName : UIColor.blackColor()])
                
            } else if let totalTipouts = totalTipouts {
                let percentage = (worker.tipout / totalTipouts)
                let percentageString = (try? formatter?.percentageStringFromNumber(percentage)).flatMap { $0 } ?? "error"

                return NSAttributedString(string:
                    isnan(percentage) || percentageString == "(0)" ? "" : "(\(percentageString))",
                    attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
            } else {
                return NSAttributedString(string: "")
            }
        }
        set {
            worker = Worker(method: .Percentage(
                try! formatter?.percentageFromString(newValue.string).doubleValue ?? (newValue.string as NSString).doubleValue),
                id: worker.id
            )
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
            guard let tipoutMethod = TipoutMethod(method: newValue.method, value: newValue.value) else { return }// WorkerViewModel.tipoutMethodFrom(newValue)
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
    
    init(worker: Worker, formatter: Formatter? = nil, totalTipouts: Double? = nil) {
        self.worker = worker
        self.totalTipouts = totalTipouts
        self.formatter = formatter
    }
    
    init(name: String, method: String, value: String, formatter: Formatter? = nil) {
        let tipoutMethod = WorkerViewModel.tipoutMethodFrom(method: method, value: value)
        worker = Worker(method: tipoutMethod, id: name)
        self.formatter = formatter
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