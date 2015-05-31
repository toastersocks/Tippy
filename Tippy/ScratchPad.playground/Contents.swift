//: Playground - noun: a place where people can play

import UIKit

func round(num: Double, toDecimalPlaces decimals: Int) -> Double {
    decimals
    var decimalFactorial = 1.0
    
    for index: Int in 0..<decimals {
        decimalFactorial = decimalFactorial * 10
    }
    
    return (round(num * decimalFactorial) / decimalFactorial)
}

var num = 14.613556

((round(num * 1000) / 1000) * 0.4) / 0.4

var something = round(num, toDecimalPlaces: 3)

(round(num / 0.25, toDecimalPlaces: 0) * 0.25)

round(num / 0.25) * 0.25

//func round(num: Int, toNearest: Double) -> Double {
//   return round(num / 0.25, toDecimalPlaces: 2) * 0.25
//}