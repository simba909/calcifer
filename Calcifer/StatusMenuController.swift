//
//  StatusMenuController.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var slider: NSSlider?

    private let displayManager = DisplayManager()

    override func awakeFromNib() {
        statusItem.title = "Calcifer"
        statusItem.menu = statusMenu

        let headerMenuItem = NSMenuItem(title: "Brightness:", action: nil, keyEquivalent: "")
        statusMenu.insertItem(headerMenuItem, at: 0)

        statusMenu.delegate = self

        setupBrightnessSlider()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @objc func sliderValueChanged() {
        if let sliderValue = slider?.doubleValue {
            let adjustedSliderValue = Int(sliderValue.rounded(toPlaces: 2) * 100)
            displayManager.setBrightness(adjustedSliderValue)
        }
    }

    private func setupBrightnessSlider() {
        let slider = NSSlider(target: self, action: #selector(sliderValueChanged))
        slider.setFrameSize(NSSize(width: 160, height: 16))
        slider.frame.origin.x = 20
        slider.frame.origin.y = 6

        self.slider = slider

        // Wrapper used for padding. But... is this really the right way to do this? :/
        let wrapper = NSView()
        wrapper.setFrameSize(NSSize(width: 192, height: 28))
        wrapper.addSubview(slider)

        let menuItem = NSMenuItem()
        menuItem.view = wrapper

        statusMenu.insertItem(menuItem, at: 1)
    }
}

extension StatusMenuController : NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        print("Menu will open!")
        // Try to get display name
        if let display = displayManager.externalDisplays.first {
            let exists = statusMenu.item(withTag: Int(display)) != nil

            let currentBrightness = displayManager.getBrightness(forDisplay: display)
            print("Display current brightness: \(currentBrightness)")

            if !exists {
                let name = displayManager.getName(forDisplay: display)
                let menuItem = NSMenuItem(title: name, action: nil, keyEquivalent: "")
                menuItem.tag = Int(display)
                statusMenu.insertItem(menuItem, at: 0)
            }
        }
    }
}
