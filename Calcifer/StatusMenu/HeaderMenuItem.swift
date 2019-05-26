//
//  HeaderMenuItem.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2019-05-26.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import AppKit

class HeaderMenuItem: NSMenuItem {
    private static var noItemsTitle: String {
        return NSLocalizedString("StatusMenuHeaderNoDisplays", comment: "")
    }

    private static var itemsPresentTitle: String {
        return NSLocalizedString("StatusMenuHeaderConnectedDisplays", comment: "")
    }

    init() {
        super.init(title: HeaderMenuItem.noItemsTitle, action: nil, keyEquivalent: "")
        tag = 0
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTitleForItemCount(_ count: Int) {
        self.title = titleForItemCount(count)
    }

    private func titleForItemCount(_ count: Int) -> String {
        if count == 0 {
            return HeaderMenuItem.noItemsTitle
        } else {
            return HeaderMenuItem.itemsPresentTitle
        }
    }
}
