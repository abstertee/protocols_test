//
//  Checks.swift
//  protocols
//
//  Created by Alex DuBois on 06/7/18.
//  Copyright © 2018 Workday, Inc. All rights reserved.
//

import Cocoa

protocol Checkable {
    var imageView: NSImageView { get set }
    var spinner: NSProgressIndicator { get set }
    var statusLabel: NSTextField { get set }
    func test() -> (success: Bool, text: String)
}

struct FirewallCheck: Checkable {
    var imageView: NSImageView
    var spinner: NSProgressIndicator
    var statusLabel: NSTextField

    func test() -> (success: Bool, text: String) {
        let status = ShellCommand().shell("defaults", "read", "/Library/Preferences/com.apple.alf.plist", "globalstate")
        let success = status.contains("1")

        return (success, "Firewall is " + (success ? "enabled" : "disabled"))
    }
}

struct UpdateCheck: Checkable {
    var imageView: NSImageView
    var spinner: NSProgressIndicator
    var statusLabel: NSTextField

    func test() -> (success: Bool, text: String) {
        let results = ShellCommand().shell("softwareupdate", "-l", "--no-scan")
        let success = results.contains("No new software available.")

        if success {
            return (success, "No pending updates")
        }

        let availableUpdates: String = {
            var updates = [String]()
            for line in results.components(separatedBy: "\n") {
                if line.contains("*") {
                    updates.append(line)
                }
            }
            return updates.joined(separator: ", ")
        }()

        return (success, availableUpdates)
    }
}
