//
//  Formatter.swift
//  Tippy
//
//  Created by James Pamplona on 11/18/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation


public class Formatter: NSObject {
    
    public enum FormatterError: ErrorType {
        case ConvertError
    }
    
    public enum PercentFormat {
        case WholeNumber
        case Decimal
    }
    
    public enum SymbolPosition {
        case Beginning, End
    }
    
    public var percentFormat: PercentFormat = .WholeNumber {
        didSet {
            switch percentFormat {
            case .WholeNumber:
                percentFormatter.multiplier = 100
            case .Decimal:
                percentFormatter.multiplier = 1
            }
        }
    }

    public var locale: NSLocale {
        get {
            return currencyFormatter.locale
        }
        set {
            currencyFormatter.locale = newValue
            percentFormatter.locale = newValue
        }
    }
    
    public var decimalSeparator: String {
        return currencyFormatter.decimalSeparator
    }
    
    private lazy var percentFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
//        formatter.percentSymbol = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.minimumSignificantDigits = 0
        formatter.maximumSignificantDigits = 4
        formatter.usesSignificantDigits = true
        return formatter
    }()
    
    private lazy var currencyFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.currencySymbol = ""
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2
//        formatter.usesSignificantDigits = true
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    public var currencySymbol: String {
        guard let symbol = NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleCurrencySymbol) as? String else { fatalError() }
        return symbol
//        return currencyFormatter.currencySymbol
    }
    
    public var percentSymbol: String {
        return percentFormatter.percentSymbol
    }
    
    public var currencySymbolPosition: SymbolPosition {
        currencyFormatter.currencySymbol = currencySymbol
        guard let string = currencyFormatter.stringFromNumber(1) else { fatalError() }
        if string.hasPrefix(currencySymbol) {
            currencyFormatter.currencySymbol = ""
            return .Beginning
        } else if string.hasSuffix(currencySymbol) {
            currencyFormatter.currencySymbol = ""
            return .End
        } else {
            fatalError()
        }
    }

    public var percentSymbolPosition: SymbolPosition {
        guard let string = percentFormatter.stringFromNumber(0.1) else { fatalError() }
        
        if string.hasPrefix(percentSymbol) {
            return .Beginning
        } else if string.hasSuffix(percentSymbol) {
            return .End
        } else {
            fatalError()
        }
    }

    public func percentageStringFromNumber(number: NSNumber) throws -> String {
        guard let string = percentFormatter.stringFromNumber(number) else { throw FormatterError.ConvertError }
            return string.stringByReplacingOccurrencesOfString(percentSymbol, withString: "")
    }
    
    public func percentageFromString(string: String) throws ->  NSNumber {
        var checkedString = string
        
        if string.hasPrefix("\(decimalSeparator)") {
            checkedString = "0" + checkedString
        }

        let percentString: String
        if !string.containsString(percentSymbol) {
            switch percentSymbolPosition {
            case .End:
                percentString = checkedString.stringByAppendingString(percentSymbol)
            case .Beginning:
                percentString = percentSymbol.stringByAppendingString(checkedString)
            }
            
        } else { percentString = checkedString }

        guard let num = percentFormatter.numberFromString(percentString) else { throw FormatterError.ConvertError }
        return num
    }
    
    public func currencyStringFromNumber(number: NSNumber) throws -> String {
        guard let string = currencyFormatter.stringFromNumber(number) else { throw FormatterError.ConvertError }
            return string.stringByReplacingOccurrencesOfString("\(currencyFormatter.currencyDecimalSeparator)00", withString: "")
            .stringByReplacingOccurrencesOfString(currencySymbol, withString: "")
    }
    
    public func currencyFromString(string: String) throws -> NSNumber {
        
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
        
        guard let num = currencyFormatter.numberFromString(checkedString) else { throw FormatterError.ConvertError }
        
        return num
    }
    
    public func formatCurrencyString(string: String) throws -> String {
        let num = try currencyFromString(string)
        let string = try currencyStringFromNumber(num)
        return string
    }
    
    public func formatPercentageString(string: String) throws -> String {
        let num = try percentageFromString(string)
        let string = try percentageStringFromNumber(num)
        return string
    }
    
    public func formatNumberString(string: String) throws -> String {
        let num = try currencyFromString(string)
        let string = try currencyStringFromNumber(num)
        return string
    }
    
//    public override init() { }

}