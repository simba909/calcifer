//
//  Logger.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2019-01-20.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import os

final class Logger {
    static func log(_ message: StaticString, type: OSLogType = .debug) {
        os_log(message, type: type)
    }
}
