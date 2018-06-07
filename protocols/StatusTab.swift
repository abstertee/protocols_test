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
        
        if status.contains("1"){
            return ["good", "Firewall is enabled"]
        } else {
            return ["bad", "Firewall is disabled"]
        }
    }
    
    // This is Check JAMF
    func checkJamf() -> Array<String> {
        // Check if Binaries are installed
        let JamfBinPath = FileManager.default
        if (JamfBinPath.fileExists(atPath: "/usr/local/bin/jamf") == false ) {
            //debugPrint("JAMF Binaries Not installed.")
            return ["bad", "JAMF Binaries Not installed."]
        }
        // Check if system is in enrolled
        let jamfEnrollStatus: String = (ShellCommand().shell("/usr/bin/profiles","-C"))
        //print(jamfEnrollStatus)
        //Log().printToLog(entry: jamfEnrollStatus)
        if jamfEnrollStatus.lowercased().range(of:("00000000-0000-0000-A000-4A414D460003").lowercased()) == nil {
            // debugPrint("Not enrolled in JSS.")
            return ["bad", "System is missing the MDM enrollment profile."]
        }
        
        let jamfConnectivity: String = (ShellCommand().shell("/usr/local/bin/jamf", "checkJSSConnection", "-retry", "3"))
        //debugPrint(jamfConnectivity)
        //Log().printToLog(entry: jamfConnectivity)
        if jamfConnectivity.lowercased().range(of:"available") == nil {
            //debugPrint("Connected")
            return ["bad", "There is no connectivity to the JSS."]
        }
        return ["good", "JAMF installed & system enrolled."]
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
