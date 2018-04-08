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

    private let displayManager = DisplayManager()

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private var displayItems = [DisplayMenuItem]()

    override init() {
        super.init()

        displayManager.delegate = self
    }

    deinit {
        displayManager.delegate = nil
    }

    override func awakeFromNib() {
        let headerMenuItem = NSMenuItem(title: "Displays:", action: nil, keyEquivalent: "")
        headerMenuItem.tag = 0

        statusMenu.insertItem(headerMenuItem, at: 0)
        statusMenu.delegate = self

        statusItem.title = "Calcifer"
        statusItem.menu = statusMenu
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    private func updateMenuItems() {
        let headerIndex = statusMenu.indexOfItem(withTag: 0)
        var separatorIndex = 0

        for (index, menuItem) in statusMenu.items.enumerated() {
            if menuItem.isSeparatorItem {
                separatorIndex = index
            }
        }

        assert(separatorIndex != 0, "Menu state invalid, can't update display items")

        // TODO -> This doesn't feel right.. Refactor at a later stage!
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

extension StatusMenuController : NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        displayManager.refreshExternalDisplays()
    }
}

extension StatusMenuController : DisplayProviderDelegate {
    func didRefresh(externalDisplays displays: [Display]) {
        let existingDisplays = displayItems.map { $0.display }
        let diff = existingDisplays.diff(displays)

        for patch in diff.patch(from: existingDisplays, to: displays) {
            switch patch {
            case .insertion(let index, let display):
                let menuItem = DisplayMenuItem(withDisplay: display)
                menuItem.delegate = self
                displayItems.insert(menuItem, at: index)
            case .deletion(let index):
                displayItems.remove(at: index)
            }
        }

        updateMenuItems()
    }
}

extension StatusMenuController: DisplayMenuItemControlsDelegate {
    func brightnessFor(_ display: Display, changedTo brightness: Int) {
        print("Brightness for \(display.name) changed to: \(brightness)")
    }
}
