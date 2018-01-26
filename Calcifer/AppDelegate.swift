//
//  AppDelegate.swift
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Starting up!")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("Shutting down")
    }
}
