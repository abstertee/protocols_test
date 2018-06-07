//
//  BackGroundCheck.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/7/18.
//  Copyright © 2018 Workday, Inc. All rights reserved.
//

import Foundation
import Cocoa

class BackGroundCheck {

    func runInBackgroundGroup() throws {
        
        if checksArray.isEmpty {
            debugPrint("Could not find anything in the array")
            return
        }
        debugPrint("The ChecksArray contains: \(checksArray.count)")
        //debugPrint(checksArray)
        let myGroup = DispatchGroup()
        for item in checksArray {
            item.statusLabel.stringValue = "Checking..."
            item.spinner.isHidden = false
            item.imageView.image = nil
            
            
            myGroup.enter()
            debugPrint("Checking object: \(item)")
            let data = item.check
            
            if data[0] == "good" {
                item.imageView.image = #imageLiteral(resourceName: "good")
            } else if data[0] == "warning" {
                item.imageView.image = #imageLiteral(resourceName: "warning-512")
            }
            else {
                item.imageView.image = #imageLiteral(resourceName: "bad")
            }
            
            
            //item.spinner.stopAnimation(self)
            myGroup.leave()
            item.spinner.stopAnimation(self)
            item.spinner.isHidden = true
            item.imageView.isHidden = false
            item.statusLabel.stringValue = data[1]
            
            
        }
        
        myGroup.notify(queue: .main) {
            
            return
            
        }
    }
    
    func runInBackgroundFull(function: @escaping () -> Array<String>, image: NSImageView, spinner: NSProgressIndicator, status: NSTextField) {
        image.image = nil
        spinner.isHidden = false
        status.stringValue = "Checking..."
        
        let taskQueue = DispatchQueue(label: "com.StatusApp.FullAppWindow", qos: .background)
        
        taskQueue.async {
            let data = function()
            //Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async(execute: {
                
                if data[0] == "good" {
                    image.image = #imageLiteral(resourceName: "good")
                } else if data[0] == "warning" {
                    image.image = #imageLiteral(resourceName: "warning-512")
                }
                else {
                    image.image = #imageLiteral(resourceName: "bad")
                }
                
                status.stringValue = data[1]
                spinner.stopAnimation(self)
                spinner.isHidden = true
               
            })
        }
    }
    
    
}
