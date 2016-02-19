//
//  TipoutViewModel.swift
//  Tippy
//
//  Created by James Pamplona on 9/11/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import UIKit
import Tipout
import SwiftyUserDefaults

final class TipoutViewModel: NSObject, TipoutViewModelType {
    // MARK: - Properties
    
    var tipoutModel = TipoutModel(roundToNearest: Defaults[.roundToNearest])
    private let formatter: Formatter?
    dynamic var count: Int {
        return tipoutModel.tipouts.count
    }
    
    dynamic var totalText: String {
        get {
            if let formatter = formatter,
                currencyText = try? formatter.currencyStringFromNumber(tipoutModel.total) {
                    return currencyText
            } else { return String(format: "%f", tipoutModel.total) }
        }
        set {
            tipoutModel.total = NSString(string: newValue).doubleValue
        }
    }
    
    dynamic var workerViewModels: [WorkerViewModelType] {
        return tipoutModel.workers.lazy.map {
            return WorkerViewModel(worker: $0, formatter: formatter, totalTipouts: tipoutModel.total)
        }
    }

    // MARK: - Methods
    
    func addWorkerWithName(name: String, method: TipoutView.TipoutViewField, value: String, atIndex index: Int) {
        guard let formatter = formatter else { return }
        let tipoutMethod: TipoutMethod
        // TODO: Make these magic strings into enums
        if !value.isEmpty {
            switch method {
            case .Hours:
                let hours = (value as NSString).doubleValue
                tipoutMethod = .Hourly(hours)
            case .Percentage:
                let percentage = try! formatter.percentageFromString(value)
                tipoutMethod = .Percentage(percentage.doubleValue)
            case .Amount:
                let currencyValue = try! formatter.currencyFromString(value)
                tipoutMethod = .Amount(currencyValue.doubleValue)
            case .Name:
                fatalError("\(method) is not a valid tipout method")
            }
        } else { tipoutMethod = .Amount(0.0) }
        
        let worker = Worker(method: tipoutMethod, id: name)
        
        if index < tipoutModel.workers.count {
            tipoutModel.workers[index] = worker
        } else if index == tipoutModel.workers.count {
            tipoutModel.workers.append(worker)
        }
    }
    
    func removeWorkerAtIndex(index: Int) {
        tipoutModel.workers.removeAtIndex(index)
    }
    
    // MARK: - Initializers
    
    init(tipoutModel: TipoutModel, formatter: Formatter?) {
        self.tipoutModel = tipoutModel
        self.formatter = formatter
    }
    
    // MARK: - KVO
    
    class func keyPathsForValuesAffectingTotalText() -> Set<NSObject> {
        return Set(["tipoutModel.total"])
    }
    class func keyPathsForValuesAffectingCount() -> Set<NSObject> {
        return Set(["tipoutModel.tipouts.count"])
    }
    class func keyPathsForValuesAffectingWorkerViewModels() -> Set<NSObject> {
        return Set(["tipoutModel.workers"])
    }
}

extension TipoutViewModel {
    
    func viewModelForWorkerAtIndex(index: Int) -> WorkerViewModelType {
        let worker = tipoutModel.workers[index]
        return WorkerViewModel(worker: worker, formatter: formatter, totalTipouts: tipoutModel.total)
    }
    
    subscript(index: Int) -> WorkerViewModelType {
        return viewModelForWorkerAtIndex(index)
    }
}