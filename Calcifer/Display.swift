//
//  Display.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-04-06.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

struct Display: Equatable {
    let id: CGDirectDisplayID
    let name: String
    let serial: String?

    init?(withId id: CGDirectDisplayID, basedOn properties: DisplayProperties?) {
        if let safeProperties = properties {
            self.id = id
            name = safeProperties.name ?? "Unknown display"
            serial = safeProperties.serial
        } else {
            return nil
        }
    }

    static func ==(lhs: Display, rhs: Display) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.serial == rhs.serial
    }
}