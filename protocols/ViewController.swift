//
//  ViewController.swift
//  protocols
//
//  Created by Abraham Tarverdi on 6/5/18.
//  Copyright © 2018 
//

import Cocoa


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

    lazy var checks: [Checkable] = {
        return [FirewallCheck(imageView: firewallIconStatus, spinner: firewallSpinner, statusLabel: firewallStatusText),
                UpdateCheck(imageView: osUpdateStatusIcon, spinner: osUpdateSpinner, statusLabel: osUpdateStatusText)]
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        runChecks()
    }

    func runChecks() {
        refreshButton.isEnabled = false

        let dispatchGroup = DispatchGroup()

        for check in checks {
            dispatchGroup.enter()

            let results = check.test()
            check.imageView.image = results.success ? #imageLiteral(resourceName: "good") : #imageLiteral(resourceName: "bad")
            check.imageView.isHidden = false
            check.statusLabel.stringValue = results.text
            check.spinner.stopAnimation(self)
            check.spinner.isHidden = true

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.refreshButton.isEnabled = true
        }
    }

    @IBAction func refreshView(_ sender: Any) {
        runChecks()
    }
    
}


