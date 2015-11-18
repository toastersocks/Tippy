//
//  WorkerViewModelType.swift
//  Tippy
//
//  Created by James Pamplona on 10/22/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa

@objc protocol WorkerViewModelType {
    
    var name: String { get set }
    var amount: String { get set }
    var hours: String { get set }
    var percentage: NSAttributedString { get set }
    //var method: (method: String, value: String) { get set }
    init(name: String, method: String, value: String)

    // RAC Stuff
    func rac_newNameTextChannel() -> RACChannelTerminal
    func rac_newAmountTextChannel() -> RACChannelTerminal
    func rac_newHoursTextChannel() -> RACChannelTerminal
    func rac_newPercentageTextChannel() -> RACChannelTerminal
    func rac_nameTextSignal() -> RACSignal!
    func rac_amountTextSignal() -> RACSignal!
    func rac_percentageTextSignal() -> RACSignal!
    func rac_hoursTextSignal() -> RACSignal!
}