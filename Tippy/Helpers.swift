//
//  Helpers.swift
//  Tippy
//
//  Created by James Pamplona on 9/13/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import UIKit

public class StartupTimeProfiler {
    public struct Event {
        let message: String
        let time: NSTimeInterval
    }
    
    static public var totalTime: NSTimeInterval {
        guard let first = events.first, last = events.last else { return 0.0 }
        return last.time - first.time
    }
    
    static public var events = [Event]()
    
    static public func addEvent(message: String) {
        events.append(Event(message: message, time: CACurrentMediaTime()))
    }
    
    static public func timeBetween(event: Event, event2: Event) -> NSTimeInterval {
        return event.time - event2.time
    }
}

extension CollectionType where Generator.Element == SubSequence.Generator.Element {
    func reduce(@noescape combine: (Generator.Element, Generator.Element) -> Generator.Element) -> Generator.Element? {
        return first.map {
            dropFirst().reduce($0, combine: combine)
        }
    }
}

func isiPhone4S() -> Bool {
    if UIScreen.mainScreen().bounds.size.height == 480 {
        return true
    } else {
        return false
    }
}

extension Set { // TODO: make this an extension for CollectionType
    func randomElement() -> Element {
        let index = self.startIndex.advancedBy(Int(arc4random_uniform(UInt32(self.count))))
        return self[index]

    }
}

extension Array {
    func removeAtIndices<ExcludeIndices: SequenceType
        where ExcludeIndices.Generator.Element == Index>
        (indices: ExcludeIndices) -> Array {
        // NOTE: PermutationGenerator is deprecated
        let orderedIndices = indices.sort().reverse()
        var selfToReturn = self
        for index in orderedIndices {
            selfToReturn.removeAtIndex(index)
        }
        return selfToReturn
            /*
         // PermutationGenerator is deprecated
         let keepIndices = self.indices.filter { !indices.contains($0) }
            return Array(PermutationGenerator(elements: self, indices: keepIndices))*/
    }
}

extension Dictionary {
    public func hasKey(key: Key) -> Bool {
        return self[key] != nil
    }
}

func debug(block: () -> Void) {
    #if DEBUG
        block()
    #endif
}

func isUITest() -> Bool {
    var isTest = false
//    debug {
        isTest = NSProcessInfo.processInfo().environment.hasKey("UITest")
//    }
    
    return isTest
}

func isTakingScreenshots() -> Bool {
    return NSProcessInfo.processInfo().environment.hasKey("TakingScreenshots")
}