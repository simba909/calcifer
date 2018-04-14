//
//  BrightnessManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

protocol DisplayProvider {
    var delegate: DisplayProviderDelegate? { get set }

    var externalDisplays: [Display] { get }

    func refreshExternalDisplays()
}

protocol DisplayProviderDelegate {
    func didRefresh(externalDisplays displays: [Display])
}

class DisplayManager: NSObject, DisplayProvider {

    private let communicator = DisplayCommunicator()

    private let maxDisplayCount: UInt32 = 8
    private var lastBrightness = 0

    var delegate: DisplayProviderDelegate?

    var externalDisplays = [Display]()

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
                if let properties = communicator.getPropertiesFor(displayId),
                    let display = Display(withId: displayId, basedOn: properties) {

                    externalDisplays.append(display)
                }
            }
        }

        delegate?.didRefresh(externalDisplays: externalDisplays)
    }

    func getBrightness(forDisplay display: CGDirectDisplayID) -> Int {
        let currentBrightness = communicator.getBrightnessFor(display)
        return Int(currentBrightness)
    }

    func setBrightness(_ value: Int) {
        if value == lastBrightness {
            return
        }

        if let displayId = fetchExternalDisplayIds().first {
            communicator.setBrightness(Int32(value), forDisplay: displayId)
            lastBrightness = value
        } else {
            print("No external displays found :(")
        }
    }

    private func fetchExternalDisplayIds() -> [CGDirectDisplayID] {
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

        return externalDisplays
    }
}
