//
//  Movement.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 17/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation

public struct Movement {
    public var id: Int
    public var name: String
    public var image: String?

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
