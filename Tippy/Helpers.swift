//
//  Helpers.swift
//  Tippy
//
//  Created by James Pamplona on 9/13/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import UIKit

open class StartupTimeProfiler {
    public struct Event {
        let message: String
        let time: TimeInterval
    }
    
    static open var totalTime: TimeInterval {
        guard let first = events.first, let last = events.last else { return 0.0 }
        return last.time - first.time
    }
    
    static open var events = [Event]()
    
    static open func addEvent(_ message: String) {
        events.append(Event(message: message, time: CACurrentMediaTime()))
    }
    
    static open func timeBetween(_ event: Event, event2: Event) -> TimeInterval {
        return event.time - event2.time
    }
}

extension Collection {
    func reduce(_ combine: (Iterator.Element, Iterator.Element) -> Iterator.Element) -> Iterator.Element? {
        return first.map {
            dropFirst().reduce($0, combine)
        }
    }
}

func isiPhone4S() -> Bool {
    if UIScreen.main.bounds.size.height == 480 {
        return true
    } else {
        return false
    }
}

extension Set { // TODO: make this an extension for CollectionType
    func randomElement() -> Element {
        let index = self.index(self.startIndex, offsetBy: Int(arc4random_uniform(UInt32(self.count))))
        return self[index]

    }
}

extension Array {
    func removeAtIndices<ExcludeIndices: Sequence>
        (_ indices: ExcludeIndices) -> Array
        where ExcludeIndices.Iterator.Element == Index {
        // NOTE: PermutationGenerator is deprecated
        let orderedIndices = indices.sorted().reversed()
        var selfToReturn = self
        for index in orderedIndices {
            selfToReturn.remove(at: index)
        }
        return selfToReturn
            /*
         // PermutationGenerator is deprecated
         let keepIndices = self.indices.filter { !indices.contains($0) }
            return Array(PermutationGenerator(elements: self, indices: keepIndices))*/
    }
}

extension Dictionary {
    public func hasKey(_ key: Key) -> Bool {
        return self[key] != nil
    }
}

func debug(_ block: () -> Void) {
    #if DEBUG
        block()
    #endif
}

func isUITest() -> Bool {
    var isTest = false
//    debug {
        isTest = ProcessInfo.processInfo.environment.hasKey("UITest")
//    }
    
    return isTest
}

func isTakingScreenshots() -> Bool {
    return ProcessInfo.processInfo.environment.hasKey("TakingScreenshots")
}
