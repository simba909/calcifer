//
//  StatusMenuController.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit
import Differ

class StatusMenuController: NSObject {

    @IBOutlet private weak var statusMenu: NSMenu!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private let displayManager = DisplayManager()
    private var displayItems: [DisplayMenuItem] = []

    override func awakeFromNib() {
        let headerMenuItem = NSMenuItem(title: "Displays:", action: nil, keyEquivalent: "")
        headerMenuItem.tag = 0

        statusMenu.insertItem(headerMenuItem, at: 0)
        statusMenu.delegate = self

        statusItem.title = "Calcifer"
        statusItem.menu = statusMenu

        displayManager.delegate = self
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    private func updateMenuItems() {
        let headerIndex = statusMenu.indexOfItem(withTag: 0)
        var separatorIndex = 0

        for (index, menuItem) in statusMenu.items.enumerated() where menuItem.isSeparatorItem {
            separatorIndex = index
        }

        assert(separatorIndex != 0, "Menu state invalid, can't update display items")

        if headerIndex.distance(to: separatorIndex) > 1 {
            for index in headerIndex + 1..<separatorIndex {
                statusMenu.removeItem(at: index)
            }
        }

        let insertionStart = headerIndex + 1
        for (index, displayItem) in displayItems.enumerated() {
            statusMenu.insertItem(displayItem.menuItem, at: insertionStart + index)
        }
    }
}

extension StatusMenuController: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        displayManager.refreshExternalDisplays()
    }
}

extension StatusMenuController: DisplayManagerDelegate {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display]) {
        let updatedDisplayItems = displays.map { display -> DisplayMenuItem in
            let menuItem = DisplayMenuItem(fromDisplay: display)
            menuItem.delegate = self
            return menuItem
        }

        // The call to updateMenuItems() will properly remove any (now) old display references
        let patches = patch(from: displayItems, to: updatedDisplayItems)
        displayItems = displayItems.apply(patches)

        updateMenuItems()
    }
}

extension StatusMenuController: DisplayMenuItemControlsDelegate {
    func brightnessSliderFor(_ display: Display, changedTo brightness: Int) {
        displayManager.setBrightnessForDisplay(display.id, to: brightness)
    }
}
