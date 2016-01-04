//
//  TipoutViewModelType.swift
//  Tippy
//
//  Created by James Pamplona on 10/22/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation

@objc protocol TipoutViewModelType {
    var count: Int { get }
    var totalText: String { get set }
    var workerViewModels: [WorkerViewModelType] { get }
    
//    func addWorkerWithName(name: String, method: String, value: String, atIndex index: Int)
    func addWorkerWithName(name: String, method: TipoutView.TipoutViewField, value: String, atIndex index: Int)
    func removeWorkerAtIndex(index: Int)
    func viewModelForWorkerAtIndex(index: Int) -> WorkerViewModelType
    subscript(index: Int) -> WorkerViewModelType { get }
}