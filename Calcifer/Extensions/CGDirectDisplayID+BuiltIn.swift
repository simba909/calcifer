//
//  CGDirectDisplayID+BuiltIn.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-04-08.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

extension CGDirectDisplayID {
    var isBuiltIn: Bool {
        return CGDisplayIsBuiltin(self) == 1
    }
}
