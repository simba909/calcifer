//
//  Display.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-04-06.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation
import DifferenceKit

struct Display {
    let id: CGDirectDisplayID
    let properties: Properties
}

// MARK: - Display+Properties
extension Display {
    struct Properties {
        var name: String
        var serial: String
    }
}

// MARK: - Equatable
extension Display.Properties: Equatable {}
extension Display: Equatable {}

// MARK: - Differentiable
extension Display: Differentiable {
    var differenceIdentifier: CGDirectDisplayID {
        return id
    }
}
