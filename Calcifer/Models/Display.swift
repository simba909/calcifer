//
//  Display.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-04-06.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation
import DifferenceKit

struct Display: Equatable {
    let id: CGDirectDisplayID
    let name: String
    let serial: String
}

extension Display: Differentiable {
    var differenceIdentifier: CGDirectDisplayID {
        return id
    }
}
