//
//  InterfaceController.swift
//  tipWatchKit Extension
//
//  Created by Emmanuel Parasirakis on 1/11/16.
//  Copyright © 2016 Manny Parasirakis. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var tipData: WKInterfaceLabel!
    
    var userDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.manny.tipCalcWatchKit")!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        updateTipData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        updateTipData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateTipData() {
        userDefaults.synchronize()
        let tipInfo = userDefaults.stringForKey("watchOutput")
        if (tipInfo != nil) {
            tipData.setText(tipInfo)
        }
    }
}
