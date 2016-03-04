//
//  DefaultsKeys.swift
//  Tippy
//
//  Created by James Pamplona on 10/28/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

@objc enum PercentageFormat: Int {
    case Decimal = 0
    case WholeNumber = 1
}

extension DefaultsKeys {
    
    static let percentageFormat = DefaultsKey<Int>("percentageFormat")
    static let roundToNearest = DefaultsKey<Double>("roundToNearest")
    static let showWalkthrough = DefaultsKey<Bool>("showWalkthrough")
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<Int?>) -> Int? {
        get {
            guard let value = unarchive(key) else { return nil }
            return value
        }
        set {
//            guard let rawValue = newValue?.rawValue else { return }
            archive(key, newValue) }
    }

}