//
//  DisplayMenuItemView.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-10-02.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit

class DisplayMenuItemView: NSView {

    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var slider: NSSlider!
    @IBOutlet private weak var percentageLabel: NSTextField!

    private var previousSliderValue = 0

    var displayName: String {
        get {
            return nameLabel.stringValue
        }
        set {
            nameLabel.stringValue = newValue
        }
    }

    var brightness: Brightness {
        get {
            return slider.integerValue
        }
        set {
            slider.integerValue = newValue
            updatePercentageLabel(newValue)
        }
    }

    var brightnessChangedClosure: ((Brightness) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        previousSliderValue = slider.integerValue
    }

    @IBAction private func sliderValueChanged(_ sender: Any) {
        let newValue = slider.integerValue

        guard newValue != previousSliderValue else {
            return
        }

        updatePercentageLabel(newValue)
        brightnessChangedClosure?(newValue)
        previousSliderValue = newValue
    }

    private func updatePercentageLabel(_ value: Int) {
        percentageLabel.stringValue = "\(value)%"
    }
}
