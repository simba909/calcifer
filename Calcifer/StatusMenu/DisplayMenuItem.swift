//
//  DisplayMenuItem.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2019-05-26.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import AppKit

protocol DisplayMenuItemDelegate: AnyObject {
    func displayMenuItem(_ item: DisplayMenuItem, changedBrightnessTo brightness: Brightness)
}

class DisplayMenuItem: NSMenuItem {

    private lazy var displayItemView: DisplayMenuItemView = {
        let instance = DisplayMenuItemView.loadInstanceFromNib()
        self.view = instance
        return instance
    }()

    private(set) var display: Display

    weak var delegate: DisplayMenuItemDelegate?

    init(display: Display) {
        self.display = display

        super.init(title: display.properties.name, action: nil, keyEquivalent: "")

        tag = Int(display.id)

        displayItemView.displayName = display.properties.name
        displayItemView.brightnessChangedClosure = { [weak self] newValue in
            self?.brightnessChangedValue(to: newValue)
        }
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setBrightness(_ brightness: Brightness) {
        displayItemView.brightness = brightness
    }

    func updateDisplay(using newDisplay: Display) {
        self.display = newDisplay
        displayItemView.displayName = display.properties.name
    }

    private func brightnessChangedValue(to newValue: Brightness) {
        delegate?.displayMenuItem(self, changedBrightnessTo: newValue)
    }
}
