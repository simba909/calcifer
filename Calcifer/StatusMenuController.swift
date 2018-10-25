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

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let headerMenuItem: NSMenuItem = {
        let instance = NSMenuItem(title: "Connected displays:", action: nil, keyEquivalent: "")
        instance.tag = 0
        return instance
    }()

    private let displayManager = DisplayManager()
    private var displays: [Display] = []
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

    private func updateMenuItems(with displays: [Display]) {
        let headerIndex = statusMenu.index(of: headerMenuItem)
        let firstDisplayIndex = headerIndex + 1
        let patches = patch(from: self.displays, to: displays)

        for patch in patches {
            switch patch {
            case .deletion(index: let offset):
                statusMenu.items.remove(at: firstDisplayIndex + offset)
            case .insertion(index: let offset, element: let display):
                let menuItem = createMenuItem(for: display)
                statusMenu.insertItem(menuItem, at: firstDisplayIndex + offset)
            }
        }

        self.displays = displays
    }

    private func createMenuItem(for display: Display) -> NSMenuItem {
        let menuItem = NSMenuItem(title: display.name, action: nil, keyEquivalent: "")
        menuItem.tag = Int(display.id)

        let view = DisplayMenuItemView.loadInstanceFromNib()
        view.setName(display.name)
        view.setSliderValue(displayManager.getBrightnessForDisplay(display))
        view.sliderValueChangedClosure = { [weak displayManager] newValue in
            displayManager?.setBrightnessForDisplay(display, to: newValue)
        }

        menuItem.view = view
        return menuItem
    }
}

extension StatusMenuController: DisplayManagerDelegate {
    func displayManager(_ manager: DisplayManager, didRefreshExternalDisplays displays: [Display]) {
        updateMenuItems(with: displays)
    }
}
