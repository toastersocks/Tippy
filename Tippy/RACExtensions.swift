//
//  RACExtensions.swift
//  Tippy
//
//  Created by James Pamplona on 9/23/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension WorkerViewModel {
    // MARK: - Channels
    func rac_newNameTextChannel() -> RACChannelTerminal {
        return RACKVOChannel(target: self, keyPath: "name", nilValue: "")["followingTerminal"]
    }
    
    func rac_newAmountTextChannel() -> RACChannelTerminal {
        return RACKVOChannel(target: self, keyPath: "amount", nilValue: "")["followingTerminal"]
    }
    
    func rac_newHoursTextChannel() -> RACChannelTerminal {
        return RACKVOChannel(target: self, keyPath: "hours", nilValue: "")["followingTerminal"]
    }
    
    func rac_newPercentageTextChannel() -> RACChannelTerminal {
        return RACKVOChannel(target: self, keyPath: "percentage", nilValue: "")["followingTerminal"]
    }
    
    // MARK: - Signals
    func rac_nameTextSignal() -> RACSignal! {
        return RACObserve(self, "name")
    }
    
    func rac_amountTextSignal() -> RACSignal! {
        return RACObserve(self, "amount")
    }
    
    func rac_percentageTextSignal() -> RACSignal! {
        return RACObserve(self, "percentage")
    }
    
    func rac_hoursTextSignal() -> RACSignal! {
        return RACObserve(self, "hours")
    }
    

}

extension TipoutViewModel {
    func rac_totalTextSignal() -> RACSignal! {
        return RACObserve(self, "totalText")
    }
    
    func rac_newWorkerViewModelsSignal() -> RACSignal! {
        return RACObserve(self, "workerViewModels")
    }
}

