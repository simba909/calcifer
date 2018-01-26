//
//  BrightnessManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

class DisplayManager: NSObject {

    private let communicator = DisplayCommunicator()

    private let maxDisplayCount: UInt32 = 8
    private var lastBrightness = 0

    func getName(forDisplay displayId: CGDirectDisplayID) -> String {
        return communicator.getPropertiesFor(displayId).name
    }

    func setBrightness(_ value: Int) {
        if value == lastBrightness {
            return
        }

        if let displayId = getExternalDisplay() {
            communicator.setBrightness(Int32(value), forDisplay: displayId)
            lastBrightness = value
        } else {
            print("No external displays found :(")
        }
    }

    private func getExternalDisplay() -> CGDirectDisplayID? {
        var activeDisplays = [CGDirectDisplayID](repeating: 0, count: Int(maxDisplayCount))
        var displayCount: UInt32 = 0

        CGGetActiveDisplayList(maxDisplayCount, &activeDisplays, &displayCount)

        var externalDisplays = [CGDirectDisplayID]()
        for index in 0..<Int(displayCount) {
            let displayId = activeDisplays[index]

            if CGDisplayIsBuiltin(displayId) == 0 {
                externalDisplays.append(displayId)
            }
        }

        return externalDisplays.first
    }
}
