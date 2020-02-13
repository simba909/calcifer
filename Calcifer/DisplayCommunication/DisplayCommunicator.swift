//
//  DisplayCommunicator.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2019-09-15.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import DDC

final class DisplayCommunicator {
    func properties(for displayID: CGDirectDisplayID) -> Display.Properties? {
        guard let ddc = DDC(for: displayID) else {
            return nil
        }

        guard let edid = ddc.edid() else {
            return nil
        }

        var displayName: String?
        var serialNumber: String?

        for descriptor in [edid.descriptors.0, edid.descriptors.1, edid.descriptors.2, edid.descriptors.3] {
            switch descriptor {
            case .displayName(let name):
                displayName = name
            case .serialNumber(let serial):
                serialNumber = serial
            default:
                break
            }
        }

        if serialNumber == nil {
            serialNumber = String(CGDisplaySerialNumber(displayID))
        }

        if let displayName = displayName, let serialNumber = serialNumber {
            return Display.Properties(name: displayName, serial: serialNumber)
        }

        return nil
    }

    func brightness(for displayID: CGDirectDisplayID) -> Int {
        guard let ddc = DDC(for: displayID) else {
            return 0
        }

        guard let (currentBrightness, _) = ddc.read(command: .brightness, tries: 2, minReplyDelay: 40) else {
            return 0
        }

        return Int(currentBrightness)
    }

    @discardableResult
    func setBrightness(_ brightness: Int, forDisplay displayID: CGDirectDisplayID) -> Bool {
        guard let ddc = DDC(for: displayID) else { return false }

        return ddc.write(command: .brightness, value: UInt16(brightness))
    }
}
