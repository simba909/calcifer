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

    var sliderValueChangedClosure: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        previousSliderValue = slider.integerValue
    }

    func setName(_ name: String) {
        nameLabel.stringValue = name
    }

    func setSliderValue(_ value: Int) {
        slider.integerValue = value
        updatePercentageLabel(value)
    }

    @IBAction private func sliderValueChanged(_ sender: Any) {
        let newValue = slider.integerValue
        if previousSliderValue != newValue {
            updatePercentageLabel(newValue)
            sliderValueChangedClosure?(newValue)
            previousSliderValue = newValue
        }
    }

    private func updatePercentageLabel(_ value: Int) {
        percentageLabel.stringValue = "\(value)%"
    }
}
