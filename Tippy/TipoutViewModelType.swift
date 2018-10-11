//
//  TipoutViewModelType.swift
//  Tippy
//
//  Created by James Pamplona on 10/22/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa

@objc protocol TipoutViewModelType {
    var count: Int { get }
    var totalText: String { get set }
    var workerViewModels: [WorkerViewModelType] { get }
    
//    func addWorkerWithName(name: String, method: String, value: String, atIndex index: Int)
    func addWorkerWithName(_ name: String, method: TipoutViewField, value: String, atIndex index: Int)
    func removeWorkerAtIndex(_ index: Int)
    func viewModelForWorkerAtIndex(_ index: Int) -> WorkerViewModelType
    subscript(index: Int) -> WorkerViewModelType { get }
    
    func rac_totalTextSignal() -> RACSignal!
    func rac_newWorkerViewModelsSignal() -> RACSignal!
}
