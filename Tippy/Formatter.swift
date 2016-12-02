//
//  Formatter.swift
//  Tippy
//
//  Created by James Pamplona on 11/18/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation


open class Formatter: NSObject {
    
    public enum FormatterError: Error {
        case convertError
    }
    
    public enum PercentFormat {
        case wholeNumber
        case decimal
    }
    
    public enum SymbolPosition {
        case beginning, end
    }
    
    open var percentFormat: PercentFormat = .wholeNumber {
        didSet {
            switch percentFormat {
            case .wholeNumber:
                percentFormatter.multiplier = 100
            case .decimal:
                percentFormatter.multiplier = 1
            }
        }
    }

    open var locale: Locale {
        get {
            return currencyFormatter.locale
        }
        set {
            currencyFormatter.locale = newValue
            percentFormatter.locale = newValue
        }
    }
    
    open var decimalSeparator: String {
        return currencyFormatter.decimalSeparator
    }
    
    fileprivate lazy var percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
//        formatter.percentSymbol = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.minimumSignificantDigits = 0
        formatter.maximumSignificantDigits = 4
        formatter.usesSignificantDigits = true
        return formatter
    }()
    
    fileprivate lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = ""
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
//        formatter.usesSignificantDigits = true
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    open var currencySymbol: String {
        guard let symbol = (Locale.autoupdatingCurrent as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as? String else { fatalError() }
        return symbol
//        return currencyFormatter.currencySymbol
    }
    
    open var percentSymbol: String {
        return percentFormatter.percentSymbol
    }
    
    open var currencySymbolPosition: SymbolPosition {
        currencyFormatter.currencySymbol = currencySymbol
        guard let string = currencyFormatter.string(from: 1) else { fatalError() }
        if string.hasPrefix(currencySymbol) {
            currencyFormatter.currencySymbol = ""
            return .beginning
        } else if string.hasSuffix(currencySymbol) {
            currencyFormatter.currencySymbol = ""
            return .end
        } else {
            fatalError()
        }
    }

    open var percentSymbolPosition: SymbolPosition {
        guard let string = percentFormatter.string(from: 0.1) else { fatalError() }
        
        if string.hasPrefix(percentSymbol) {
            return .beginning
        } else if string.hasSuffix(percentSymbol) {
            return .end
        } else {
            fatalError()
        }
    }

    open func percentageStringFromNumber(_ number: NSNumber, stripSymbol: Bool) throws -> String {
        guard let stringWithSymbol = percentFormatter.string(from: number) else { throw FormatterError.convertError }
        return stripSymbol ? stringWithSymbol.replacingOccurrences(of: percentSymbol, with: "") : stringWithSymbol
    }
    
    open func percentageFromString(_ string: String) throws ->  NSNumber {
        var checkedString = string
        
        if string.hasPrefix("\(decimalSeparator)") {
            checkedString = "0" + checkedString
        }

        let percentString: String
        if !string.contains(percentSymbol) {
            switch percentSymbolPosition {
            case .end:
                percentString = checkedString + percentSymbol
            case .beginning:
                percentString = percentSymbol + checkedString
            }
            
        } else { percentString = checkedString }

        guard let num = percentFormatter.number(from: percentString) else { throw FormatterError.convertError }
        return num
    }
    
    open func currencyStringFromNumber(_ number: NSNumber, stripSymbol: Bool) throws -> String {
        guard let string = currencyFormatter.string(from: number) else { throw FormatterError.convertError }
        let trailingZerosStripped = string.replacingOccurrences(of: "\(currencyFormatter.currencyDecimalSeparator)00", with: "")
        if stripSymbol {
            return trailingZerosStripped.replacingOccurrences(of: currencySymbol, with: "")
        } else {
            return trailingZerosStripped
        }
    }
    
    open func currencyFromString(_ string: String) throws -> NSNumber {
        
        /*let amountString: String
        if !string.containsString(currencySymbol) {
            switch currencySymbolPosition {
            case .End:
                amountString = string.stringByAppendingString(currencySymbol)
            case .Beginning:
                amountString = currencySymbol.stringByAppendingString(string)
            }
            
        } else { amountString = string }*/
        var checkedString = string
        if string.hasPrefix("\(decimalSeparator)") {
                checkedString = "0" + checkedString
        }
        
        guard let num = currencyFormatter.number(from: checkedString) else { throw FormatterError.convertError }
        
        return num
    }
    
    open func formatCurrencyString(_ string: String, stripSymbol: Bool) throws -> String {
        let num = try currencyFromString(string)
        let string = try currencyStringFromNumber(num, stripSymbol: stripSymbol)
        return string
    }
    
    open func formatPercentageString(_ string: String, stripSymbol: Bool) throws -> String {
        let num = try percentageFromString(string)
        let string = try percentageStringFromNumber(num, stripSymbol: stripSymbol)
        return string
    }
    
    open func formatNumberString(_ string: String) throws -> String {
        let num = try currencyFromString(string)
        let string = try currencyStringFromNumber(num, stripSymbol: true)
        return string
    }
    
//    public override init() { }

}
