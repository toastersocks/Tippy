//
//  TipoutView+RAC.swift
//  Tippy
//
//  Created by James Pamplona on 7/22/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension EditableTipoutView {
    
    // MARK: - Channels

    public func rac_newAmountTextChannel() -> RACChannelTerminal! {
    return amountField.rac_newTextChannel()
    }
    public func rac_newPercentageTextChannel() -> RACChannelTerminal! {
        return percentageField.rac_newTextChannel()
    }
    public func rac_newHoursTextChannel() -> RACChannelTerminal! {
        return hoursField.rac_newTextChannel()
    }
    public func rac_newActiveFieldTextChannel() -> RACChannelTerminal? {
        
        return activeTextField?.rac_newTextChannel()
    }
    
    public func rac_newNameTextChannel() -> RACChannelTerminal! {
        return nameField.rac_newTextChannel()
    }
    
    
    // MARK: - Signals
    
    public func rac_amountTextSignal() -> RACSignal! {
        return amountField.rac_textSignal()
    }
    
    public func rac_percentageTextSignal() -> RACSignal! {
        return percentageField.rac_textSignal()
    }
    public func rac_hoursTextSignal() -> RACSignal! {
        return hoursField.rac_textSignal()
    }
    public func rac_activeFieldTextSignal() -> RACSignal? {
        
        return activeTextField?.rac_textSignal()
    }
    
    public func rac_nameTextSignal() -> RACSignal! {
        return nameField.rac_textSignal()
    }

    
}