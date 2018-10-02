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

    private var previousSliderValue = 0

    var sliderValueChangedClosure: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        previousSliderValue = slider.integerValue
    }

    func setName(_ name: String) {
        nameLabel.stringValue = name
    }

    @IBAction func sliderValueChanged(_ sender: Any) {
        if previousSliderValue != slider.integerValue {
            sliderValueChangedClosure?(slider.integerValue)
            previousSliderValue = slider.integerValue
        }
    }
}
