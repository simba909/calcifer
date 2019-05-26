//
//  StatusMenuController.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit
import DifferenceKit

final class StatusMenuController: NSObject {

    @IBOutlet private weak var statusMenu: NSMenu!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let headerMenuItem = HeaderMenuItem()

    private let displayManager = DisplayManager()
    private var displays: [Display] = [] {
        didSet {
            headerMenuItem.updateTitleForItemCount(displays.count)
        }
    }
    private var displayMenuItems: [NSMenuItem] = []

    override func awakeFromNib() {
        statusMenu.insertItem(headerMenuItem, at: 0)

        let statusImage = NSImage(imageLiteralResourceName: "StatusItemIcon")
        statusImage.size = NSSize(width: 18, height: 18)
        statusItem.button?.image = statusImage
        statusItem.menu = statusMenu

        displayManager.delegate = self
        displayManager.monitorDisplayChanges()
        displayManager.refreshExternalDisplays()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    private func updateMenuItems(with newDisplays: [Display]) {
        let stagedChangeset = StagedChangeset(source: self.displays, target: newDisplays)

        guard let changeset = stagedChangeset.first else {
            return
        }

        let headerIndex = statusMenu.index(of: headerMenuItem)
        let firstDisplayIndex = headerIndex + 1

        changeset.elementUpdated.forEach { path in
            guard let statusMenuItem = statusMenu.items[firstDisplayIndex + path.element] as? DisplayMenuItem else {
                return
            }

            statusMenuItem.updateDisplay(using: newDisplays[path.element])
        }

        changeset.elementDeleted.forEach { path in
            statusMenu.items.remove(at: firstDisplayIndex + path.element)
        }

        changeset.elementInserted.forEach { path in
            let menuItem = createMenuItem(for: newDisplays[path.element])
            statusMenu.insertItem(menuItem, at: firstDisplayIndex + path.element)
        }

        self.displays = newDisplays
    }

    private func createMenuItem(for display: Display) -> NSMenuItem {
        let menuItem = DisplayMenuItem(display: display)
        menuItem.delegate = self

        let persistedBrightness = displayManager.getBrightness(for: display)
        menuItem.setBrightness(persistedBrightness)

        return menuItem
    }
}

extension StatusMenuController: DisplayManagerDelegate {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display]) {
        updateMenuItems(with: displays)
    }
}

extension StatusMenuController: DisplayMenuItemDelegate {
    func displayMenuItem(_ item: DisplayMenuItem, changedBrightnessTo brightness: Brightness) {
        displayManager.setBrightness(for: item.display, to: brightness)
    }
}
