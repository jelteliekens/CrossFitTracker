//
//  Array+Extensions.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 16/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

// Treat an array as a stack.
extension Array {

    mutating func push(_ newElement: Element) {
        self.append(newElement)
    }

    mutating func append(_ newElements: [Element]?) {
        for e in newElements ?? [] {
            self.append(e)
        }
    }

    mutating func pop() -> Element? {
        return self.removeLast()
    }

    func peekAtStack() -> Element? {
        return self.last
    }
}
