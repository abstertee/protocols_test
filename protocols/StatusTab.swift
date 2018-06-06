//
//  StatusTab.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/5/18.
//  Copyright © 2018 
//

import Foundation

class StatusTab {
    func firewallCheck() -> Array<String> {
        let status = ShellCommand().shell("defaults", "read", "/Library/Preferences/com.apple.alf.plist", "globalstate")
        //print(status)
        //sleep(5)
        if status.contains("1"){
            return ["good", "Firewall is enabled"]
        } else {
            return ["bad", "Firewall is disabled"]
        }
    }
}

class OSUpdate {
    func short_osUpdateCheck() -> Array<String> {
        let updates = ShellCommand().shell("softwareupdate", "-l", "--no-scan")
        return osUpdateCheck(updates)
    }
    
    func long_osUpdateCheck() -> Array<String> {
        
        let updates = ShellCommand().shell("softwareupdate", "-l")
        return osUpdateCheck(updates)
    }
    
    func osUpdateCheck(_ updates: String) -> Array<String> {
        var pending = [String]()
        
        if updates.contains("Software Update found the following new or updated software:") {
            let updateArr = updates.components(separatedBy: "\n")
            for u in updateArr {
                if u.contains("*") {
                    debugPrint(u)
                    pending.append(u)
                }
            }
            if pending.isEmpty {
                return ["warning", "Could not collect pending updates list."]
            }
            let pendingString = pending.joined(separator: ", ")
            return ["warning", pendingString]
            
        } else {
            return ["good", "No pending updates"]
        }
        
    }
}
