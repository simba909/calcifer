//
//  PreferenceManager.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-10-04.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Foundation

class PreferenceManager {
    private let preferences = UserDefaults.standard

    func integer(forKey key: String) -> Int {
        return preferences.integer(forKey: key)
    }

    func set(_ value: Int, forKey key: String) {
        preferences.set(value, forKey: key)
    }
}
