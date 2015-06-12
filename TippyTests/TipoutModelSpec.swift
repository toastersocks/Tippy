//
//  TipoutModelSpec.swift
//  Tippy
//
//  Created by James Pamplona on 6/11/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import Foundation
import Tippy
import Fox
import Nimble
import NimbleFox
import Quick


private func generateDouble(f: Double -> Bool) -> FOXGenerator {
    return forAll(FOXDouble()) {
        (floatNum: AnyObject!) -> Bool in
        return f(floatNum as! Double)
    }
}

class TipoutModelSpec: QuickSpec {
    override func spec() {

        describe("a TipoutModel") {
            var tipoutModel: TipoutModel!
            
            beforeEach {
                tipoutModel = TipoutModel()

                tipoutModel.workersHours = [4.0, 3.0, 1.0]
            }
            
            describe("its total") {
                it("should be equal to the total of all worker tipouts") {
                    let property = generateDouble() {
                        (num: Double) in
                        tipoutModel.total = num
                        
                        return tipoutModel.workersTipOuts.reduce(tipoutModel.kitchenTipout, combine:{ $0 + $1 }) == tipoutModel.total
                    }
//                    expect(tipoutModel.total).to(equal(tipoutModel.workersTipOuts.reduce(tipoutModel.kitchenTipout, combine:{ $0 + $1 })))
                    expect(property).to(hold())
                }
            }
            
            /**
            *  Sanity check
            */
            describe("its kitchen tipout") {
                context("when the total tips are 100") {
                    it("should be 30") {
                        tipoutModel.total = 100.0
                        expect(tipoutModel.kitchenTipout) == 30
                    }
                }
            }
        }
    }
}