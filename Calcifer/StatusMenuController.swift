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

    private let brightnessManager = BrightnessManager()

    override func awakeFromNib() {
        statusItem.title = "Calcifer"
        statusItem.menu = statusMenu

        let headerMenuItem = NSMenuItem(title: "Brightness:", action: nil, keyEquivalent: "")
        statusMenu.insertItem(headerMenuItem, at: 0)

        setupBrightnessSlider()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @objc func sliderValueChanged() {
        if let sliderValue = slider?.doubleValue {
            brightnessManager.setBrightness(sliderValue)
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
