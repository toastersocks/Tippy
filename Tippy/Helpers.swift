//
//  Helpers.swift
//  Tippy
//
//  Created by James Pamplona on 9/13/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation
import UIKit

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
            let keepIndices = self.indices.filter { !indices.contains($0) }
            return Array(PermutationGenerator(elements: self, indices: keepIndices))
    }
}
