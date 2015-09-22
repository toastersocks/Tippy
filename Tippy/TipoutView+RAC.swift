//
//  TipoutView+RAC.swift
//  Tippy
//
//  Created by James Pamplona on 7/22/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension TipoutView {
    public var rac_newAmountTextChannel: RACChannelTerminal {
    return amountField.rac_newTextChannel()
    }
    public var rac_newPercentageTextChannel: RACChannelTerminal {
        return percentageField.rac_newTextChannel()
    }
    public var rac_newHoursTextChannel: RACChannelTerminal {
        return hoursField.rac_newTextChannel()
    }
    public var rac_newActiveFieldTextChannel: RACChannelTerminal? {
        
        return activeTextField?.rac_newTextChannel()
    }
    
    public var rac_newNameTextChannel: RACChannelTerminal {
        return nameField.rac_newTextChannel()
    }
}