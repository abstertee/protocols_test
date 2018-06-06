//
//  ViewController.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/5/18.
//  Copyright © 2018 
//

import Cocoa

protocol BackgroundCheck {
    var check: Array<String> { get set }
    var imageView: NSImageView { get set }
    var spinner: NSProgressIndicator { get set }
    var statusLabel: NSTextField { get set }
}

class ViewController: NSViewController {
    
    struct StatusTabChecks {
        var imageView: NSImageView
        
        var spinner: NSProgressIndicator
        
        var statusLabel: NSTextField
        
        var check: Array<String>
        
       /*init(imageView: NSImageView, spinner: NSProgressIndicator, statusLabel: NSTextField, check: Array<String>) {
            self.imageView.isHidden = false
            self.spinner.stopAnimation(Any?.self)
            self.spinner.isHidden = true
            self.statusLabel.stringValue = check[1]
        }*/
    }
    
    @IBOutlet weak var firewallStatusText: NSTextField!
    @IBOutlet weak var firewallIconStatus: NSImageView!
    @IBOutlet weak var firewallSpinner: NSProgressIndicator!
    @IBOutlet weak var firewallIcon: NSImageView!
    @IBOutlet weak var refreshButton: NSButtonCell!
    
    @IBOutlet weak var osUpdateLogo: NSImageView!
    @IBOutlet weak var osUpdateSpinner: NSProgressIndicator!
    @IBOutlet weak var osUpdateStatusIcon: NSImageView!
    @IBOutlet weak var osUpdateStatusText: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        runChecks()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    var checksArray: [StatusTabChecks] = []
    
    func runChecks() {
        let firewallObject = StatusTabChecks(imageView: firewallIconStatus, spinner: firewallSpinner, statusLabel: firewallStatusText, check: StatusTab().firewallCheck())
        let osupdateObject = StatusTabChecks(imageView: osUpdateStatusIcon, spinner: osUpdateSpinner, statusLabel: osUpdateStatusText, check: OSUpdate().long_osUpdateCheck()) 
        //debugPrint(firewallObject)
        //debugPrint(firewallObject.check[0...1])
        checksArray.append(firewallObject)
        checksArray.append(osupdateObject)
        runInBackgroundGroup_Throw()
    }

    @objc func runInBackgroundGroup_Throw() {
       
        do {
            
            try runInBackgroundGroup()
            
        }
        catch {
            debugPrint(error)
        }
    }
    
    func runInBackgroundGroup() throws {
        
        if checksArray.isEmpty {
            debugPrint("Could not find anything in the array")
            return
        }
        debugPrint("The ChecksArray contains: \(checksArray.count)")
        debugPrint(checksArray)
        let myGroup = DispatchGroup()
        for item in checksArray {
            myGroup.enter()
            
            let data = item.check
            
            if data[0] == "good" {
                item.imageView.image = #imageLiteral(resourceName: "good")
            } else {
                item.imageView.image = #imageLiteral(resourceName: "bad")
            }
            item.imageView.isHidden = false
            item.statusLabel.stringValue = data[1]
            item.spinner.stopAnimation(self)
            item.spinner.isHidden = true
            myGroup.leave()
        }
        
        
        myGroup.notify(queue: .main) {
            self.refreshButton.isEnabled = true
            return
            
        }
    }
    
    
    @IBAction func refreshView(_ sender: Any) {
        refreshButton.isEnabled = false
        checksArray.removeAll()
        runChecks()
        
    }
    
}

