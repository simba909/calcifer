//
//  BrightnessManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

protocol DisplayManagerDelegate: class {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display])
}

class DisplayManager: NSObject {

    private let communicator = DisplayCommunicator()
    private let maxDisplayCount: UInt32 = 8

    weak var delegate: DisplayManagerDelegate?

    private(set) var externalDisplays: [Display] = []

    func refreshExternalDisplays() {
        print("Updating list of available displays...")

        let externalDisplayIds = fetchExternalDisplayIds()
        var oldDisplayIds = [CGDirectDisplayID]()

        // Remove any displays that are no longer connected
        for (index, display) in externalDisplays.enumerated().reversed() {
            oldDisplayIds.append(display.id)

            if !externalDisplayIds.contains(display.id) {
                externalDisplays.remove(at: index)
            }
        }

        // Add all new displays
        for displayId in externalDisplayIds {
            if !oldDisplayIds.contains(displayId) {
                if let properties = communicator.getPropertiesFor(displayId) {
                    let display = Display(id: displayId, name: properties.name, serial: properties.serial)
                    externalDisplays.append(display)
                }
            }
        }

        delegate?.displayManager(self, didRefreshExternalDisplays: externalDisplays)
    }

    func getBrightness(forDisplay display: CGDirectDisplayID) -> Int {
        let currentBrightness = communicator.getBrightnessFor(display)
        return Int(currentBrightness)
    }

    func setBrightness(forDisplay display: CGDirectDisplayID, to value: Int) {
        communicator.setBrightness(Int32(value), forDisplay: display)
    }

    private func fetchExternalDisplayIds() -> [CGDirectDisplayID] {
        var activeDisplays: [CGDirectDisplayID] = Array(repeating: 0, count: Int(maxDisplayCount))
        var displayCount: UInt32 = 0

        CGGetActiveDisplayList(maxDisplayCount, &activeDisplays, &displayCount)

        var externalDisplays: [CGDirectDisplayID] = []
        for index in 0..<Int(displayCount) {
            let displayId = activeDisplays[index]

            if CGDisplayIsBuiltin(displayId) == 0 {
                externalDisplays.append(displayId)
            }
        }

        return externalDisplays
    }
}
