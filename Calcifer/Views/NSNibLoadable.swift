//
//  NSNibLoadable.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-10-02.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import AppKit

protocol NSNibLoadable {
    static func loadInstanceFromNib() -> Self
}

extension NSView: NSNibLoadable {}

extension NSNibLoadable where Self: NSView {
    static func loadInstanceFromNib() -> Self {
        let className = String(describing: Self.self)
        let bundle = Bundle(for: self)

        var topLevelObjects: NSArray?
        let nibLoaded = bundle.loadNibNamed(className, owner: nil, topLevelObjects: &topLevelObjects)

        guard nibLoaded,
            let firstTopLevelObject = topLevelObjects?.first(where: { $0 is Self }) as? Self
            else {
                let message = "Failed to load \(className) from nib!"
                    + " Are you sure it's the single/first top level object in the nib?"
                fatalError(message)
        }

        return firstTopLevelObject
    }
}
