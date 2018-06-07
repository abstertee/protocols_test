//
//  ViewController.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/5/18.
//  Copyright © 2018 
//

import Cocoa

protocol BackGroundCheckProtocol {
    var check: Array<String> { get set }
    var imageView: NSImageView { get set }
    var spinner: NSProgressIndicator { get set }
    var statusLabel: NSTextField { get set }
}

struct StatusTabChecks {
    var imageView: NSImageView
    
    var spinner: NSProgressIndicator
    
    var statusLabel: NSTextField
    
    var check: Array<String>
    
}

var checksArray: [StatusTabChecks] = []

class ViewController: NSViewController {
    
   
    
    @IBOutlet weak var firewallStatusText: NSTextField!
    @IBOutlet weak var firewallIconStatus: NSImageView!
    @IBOutlet weak var firewallSpinner: NSProgressIndicator!
    @IBOutlet weak var firewallIcon: NSImageView!
    @IBOutlet weak var refreshButton: NSButtonCell!
    
    @IBOutlet weak var osUpdateLogo: NSImageView!
    @IBOutlet weak var osUpdateSpinner: NSProgressIndicator!
    @IBOutlet weak var osUpdateStatusIcon: NSImageView!
    @IBOutlet weak var osUpdateStatusText: NSTextField!
    
    @IBOutlet weak var jamfStatusIcon: NSImageView!
    @IBOutlet weak var jamfSpinner: NSProgressIndicator!
    @IBOutlet weak var jamfLogo: NSImageView!
    @IBOutlet weak var jamfStatusText: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        osUpdateSpinner.startAnimation(self)
        firewallSpinner.startAnimation(self)
        jamfSpinner.startAnimation(self)
        
        // Do any additional setup after loading the view.
        runChecks()
        //runChecks_Queue()
    }
    func runChecks_Queue() {
        BackGroundCheck().runInBackgroundFull(function: StatusTab().firewallCheck, image: firewallIconStatus, spinner: firewallSpinner, status: firewallStatusText)
        BackGroundCheck().runInBackgroundFull(function: OSUpdate().long_osUpdateCheck, image: osUpdateStatusIcon, spinner: osUpdateSpinner, status: osUpdateStatusText)
        BackGroundCheck().runInBackgroundFull(function: StatusTab().checkJamf, image: jamfStatusIcon, spinner: jamfSpinner, status: jamfStatusText)
        refreshButton.isEnabled = true
    }
    
    func runChecks() {
        let firewallObject = StatusTabChecks(imageView: firewallIconStatus, spinner: firewallSpinner, statusLabel: firewallStatusText, check: StatusTab().firewallCheck())
        let osupdateObject = StatusTabChecks(imageView: osUpdateStatusIcon, spinner: osUpdateSpinner, statusLabel: osUpdateStatusText, check: OSUpdate().long_osUpdateCheck())
        let jamfObject = StatusTabChecks(imageView: jamfStatusIcon, spinner: jamfSpinner, statusLabel: jamfStatusText, check: StatusTab().checkJamf())
        
        checksArray.append(firewallObject)
        checksArray.append(osupdateObject)
        checksArray.append(jamfObject)
        debugPrint(checksArray.count)
        runInBackgroundGroup_Throw()
    }

    @objc func runInBackgroundGroup_Throw() {
       
        do {
            
            //try BackGroundCheck().runInBackgroundGroup()
            try MixedChecks().runInBackgroundGroup()
            refreshButton.isEnabled = true
            
        }
        catch {
            debugPrint(error)
        }
    }
  
    
    @IBAction func refreshView(_ sender: Any) {
        refreshButton.isEnabled = false
        checksArray.removeAll()
        runChecks()
        //runChecks_Queue()
        
    }
    
}

