//
//  BrightnessManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit

protocol DisplayManagerDelegate: class {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display])
}

private extension Display {
    var brightnessPreferenceKey: String {
        return "\(serial).brightness"
    }
}

class DisplayManager {

    private static let maxDisplayCount: UInt32 = 8
    private static let defaultDisplayBrightness = 35

    private let preferenceManager = PreferenceManager()
    private let communicator = DisplayCommunicator()

    weak var delegate: DisplayManagerDelegate?

    private(set) var connectedDisplays: [Display] = []
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

        let displayIds = fetchExternalDisplayIds()
        let displays = displayIds.compactMap { displayId -> Display? in
            guard let properties = communicator.getPropertiesFor(displayId) else {
                return nil
            }

            return Display(id: displayId, name: properties.name, serial: properties.serial)
        }

        connectedDisplays = displays
        delegate?.displayManager(self, didRefreshExternalDisplays: displays)
    }

    func getBrightnessForDisplay(_ display: Display) -> Int {
        // The DisplayCommunicator _can_ be used to fetch display brightness from the screen, but
        // that turns out to not work in all cases and can even freeze some systems.
        // Instead we use the PreferenceManager to persist the last used brightness.
        let persistedBrightness = preferenceManager.integer(forKey: display.brightnessPreferenceKey)
        return persistedBrightness > 0 ? persistedBrightness : DisplayManager.defaultDisplayBrightness
    }

    func setBrightnessForDisplay(_ display: Display, to value: Int) {
        communicator.setBrightness(Int32(value), forDisplay: display.id)
        preferenceManager.set(value, forKey: display.brightnessPreferenceKey)
    }

    @objc private func displayConfigurationUpdated(notification: Notification) {
        refreshExternalDisplays()
    }

    private func fetchExternalDisplayIds() -> [CGDirectDisplayID] {
        var activeDisplays: [CGDirectDisplayID] = Array(repeating: 0, count: Int(DisplayManager.maxDisplayCount))
        var displayCount: UInt32 = 0

        CGGetActiveDisplayList(DisplayManager.maxDisplayCount, &activeDisplays, &displayCount)

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
