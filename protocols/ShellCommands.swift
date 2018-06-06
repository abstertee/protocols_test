//
//  ShellCommands.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/5/18.
//  Copyright © 2018 
//

import Foundation

class ShellCommand {
    //Function to run a terminal command and return the output as String
    func shell(_ args: String...) -> String {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        return (output as String)
        //return task.terminationStatus
    }
}
