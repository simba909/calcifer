//
//  BrightnessManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit
import Differ

protocol DisplayManagerDelegate: class {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display])
}

class DisplayManager: NSObject {

    private let communicator = DisplayCommunicator()
    private let maxDisplayCount: UInt32 = 8

    weak var delegate: DisplayManagerDelegate?

    private(set) var externalDisplays: [Display] = []
    private(set) var monitoringChanges = false

    func monitorDisplayChanges() {
        if monitoringChanges { return }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(displayConfigurationUpdated),
                                       name: NSApplication.didChangeScreenParametersNotification,
                                       object: nil)

        monitoringChanges = true
    }

    func stopMonitoringDisplayChanges() {
        guard monitoringChanges else { return }

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self,
                                          name: NSApplication.didChangeScreenParametersNotification,
                                          object: nil)

        monitoringChanges = false
    }

    func refreshExternalDisplays() {
        print("Updating list of available displays...")

        let externalDisplayIds = fetchExternalDisplayIds()
        let oldDisplayIds = externalDisplays.map { $0.id }

        let diff = oldDisplayIds.diff(externalDisplayIds)
        let patches = diff.patch(from: oldDisplayIds, to: externalDisplayIds)

        for patch in patches {
            switch patch {
            case .deletion(index: let index):
                externalDisplays.remove(at: index)
            case .insertion(index: _, element: let displayID):
                guard let properties = communicator.getPropertiesFor(displayID) else {
                    continue
                }

                let display = Display(id: displayID, name: properties.name, serial: properties.serial)
                externalDisplays.append(display)
            }
        }

        delegate?.displayManager(self, didRefreshExternalDisplays: externalDisplays)
    }

    func getBrightnessForDisplay(_ display: CGDirectDisplayID) -> Int {
        let currentBrightness = communicator.getBrightnessFor(display)
        return Int(currentBrightness)
    }

    func setBrightnessForDisplay(_ display: CGDirectDisplayID, to value: Int) {
        communicator.setBrightness(Int32(value), forDisplay: display)
    }

    @objc private func displayConfigurationUpdated(notification: Notification) {
        refreshExternalDisplays()
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
