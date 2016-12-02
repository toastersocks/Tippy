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
    case beginning
    case end
    case other
}

@objc enum Method: Int {
    case hour, percent, amount
}

final class WorkerViewModel: NSObject, WorkerViewModelType {
    
    // MARK: - Properties
    
    var currencySymbolPosition: SymbolPosition {
        guard let formatter = formatter else { return .other }
        
        switch formatter.currencySymbolPosition {
        case .beginning:
            return .beginning
        case .end:
            return .end
        }
    }
    
    var percentSymbolPosition: SymbolPosition {
        guard let formatter = formatter else { return .other }
        
        switch formatter.percentSymbolPosition {
        case .beginning:
            return .beginning
        case .end:
            return .end
        }
    }
    
    var percentSymbol: String {
        return formatter?.percentSymbol ?? ""
    }
    
    var currencySymbol: String {
        return formatter?.currencySymbol ?? ""
    }
    
    dynamic var worker: Worker
    let formatter: Formatter?
    
    /// - note: This is used to optionally calculate the percentage of the Worker tipout from the total tipouts
    fileprivate var totalTipouts: Double?
    
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
                let currencyString = try? formatter.currencyStringFromNumber(worker.tipout, stripSymbol: true) {
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
            let attributedString: NSAttributedString
            
            switch (worker.method, totalTipouts) {
                
            case (.Percentage(let percentage), _):
                
                let percentageString = (try? formatter?.percentageStringFromNumber(percentage, stripSymbol: true)).flatMap { $0 } ?? "\(percentage)"
                attributedString = NSAttributedString(string: percentageString,
                                                      attributes: [NSForegroundColorAttributeName : UIColor.blackColor()])
                
            case (_, let totalTipouts?):
                
                let percentage = (worker.tipout / totalTipouts)
                let percentageString = (try? formatter?.percentageStringFromNumber(percentage, stripSymbol: true)).flatMap { $0 } ?? "error"
                attributedString = NSAttributedString(string:
                    isnan(percentage) || percentageString == "(0)" ? "" : "(\(percentageString))",
                                                      attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
            default:
                
                 attributedString = NSAttributedString(string: "")
            }
            return attributedString
            
        }
        
        set {
            worker = Worker(method: .Percentage(
                try! formatter?.percentageFromString(newValue.string).doubleValue ?? (newValue.string as NSString).doubleValue),
                            id: worker.id
            )
        }
    }
    
    var method: Method {
        
        switch worker.method {
        case .Amount:
            return .amount
        case .Hourly:
            return .hour
        case .Percentage:
            return .percent
        case .Function:
            fatalError("Function method not supported")
        }
    }
    
    var value: String {
        switch worker.method {
        case .Amount:
            return amount
        case .Hourly:
            return hours
        case .Percentage:
            return percentage.string
        case .Function:
            return ""
        }
    }
    
    class internal func tipoutMethodFrom(method: String, value: String) -> TipoutMethod {
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
        return Set(["worker", "worker.id"]) as Set<NSObject>
    }
    
    class func keyPathsForValuesAffectingAmount() -> Set<NSObject> {
        return Set(["worker", "worker.tipout"]) as Set<NSObject>
    }
    
    class func keyPathsForValuesAffectingHours() -> Set<NSObject> {
        return Set(["worker", "worker.method"]) as Set<NSObject>
    }
    
    class func keyPathsForValuesAffectingPercentage() -> Set<NSObject> {
        return Set(["worker", "worker.tipout", "worker.method", "totalTipouts"]) as Set<NSObject>
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
    
    func isEqualToWorkerViewModel(_ object: AnyObject?) -> Bool {
        return isEqual(object)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let workerViewModel = object as? WorkerViewModel else { return false }
        return self.worker == workerViewModel.worker
    }
}
