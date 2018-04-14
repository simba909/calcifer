//
//  DisplayMenuItem.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-04-06.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit

protocol DisplayMenuItemControlsDelegate {
    func brightnessFor(_ display: Display, changedTo brightness: Int)
}

class DisplayMenuItem {
    private let menuViewVerticalPadding = CGFloat(integerLiteral: 4)
    private let menuViewVerticalItemPadding = CGFloat(integerLiteral: 4)
    private let menuViewLeftPadding = CGFloat(integerLiteral: 20)

    private lazy var brightnessSlider: NSSlider = {
        let slider = NSSlider(target: self, action: #selector(sliderValueChanged))
        slider.setFrameSize(NSSize(width: 160, height: 16))

        return slider
    }()

    let display: Display

    lazy var menuItem: NSMenuItem = {
        let item = NSMenuItem(title: display.name, action: nil, keyEquivalent: "")
        item.tag = Int(display.id)
        item.view = makeMenuItemView()

        return item
    }()

    var delegate: DisplayMenuItemControlsDelegate?

    init(fromDisplay display: Display) {
        self.display = display
    }

    @objc private func sliderValueChanged() {
        let adjustedSliderValue = Int(brightnessSlider.doubleValue.rounded(toPlaces: 2) * 100)
        delegate?.brightnessFor(display, changedTo: adjustedSliderValue)
    }

    private func makeMenuItemView() -> NSView {
        brightnessSlider.frame.origin.x = menuViewLeftPadding
        brightnessSlider.frame.origin.y += menuViewVerticalPadding

        let label = NSTextField(labelWithString: display.name)
        label.textColor = NSColor.disabledControlTextColor
        label.frame.origin.x = menuViewLeftPadding
        label.frame.origin.y = brightnessSlider.frame.maxY + menuViewVerticalItemPadding

        let wrapperHeight = brightnessSlider.frame.height + label.frame.height +
            menuViewVerticalPadding * 2 + menuViewVerticalItemPadding

        let wrapper = NSView(frame: NSRect(x: 0, y: 0, width: 192, height: wrapperHeight))
        wrapper.addSubview(brightnessSlider)
        wrapper.addSubview(label)

        return wrapper
    }
}

extension DisplayMenuItem: Equatable {
    static func == (lhs: DisplayMenuItem, rhs: DisplayMenuItem) -> Bool {
        return lhs.display == rhs.display
    }
}
