//
//  InterfaceController.swift
//  tipWatchKit Extension
//
//  Created by Emmanuel Parasirakis on 1/11/16.
//  Copyright © 2016 Manny Parasirakis. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class InterfaceController: WKInterfaceController {
    @IBOutlet var tipData: WKInterfaceLabel!
    
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
    
    func getManagedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UI.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }

    func updateTipData() {
        let tipInfo = getWatchData()
        tipData.setText(tipInfo)
    }

    func getWatchData() -> String {
        let watchDataFetch = NSFetchRequest(entityName: "WatchData")
        
        do {
            let fetchedWatchData = try getManagedObjectContext().executeFetchRequest(watchDataFetch) as! [WatchData]
            return fetchedWatchData.count > 0 ? fetchedWatchData[0].tipData! : "No Data"
        } catch {
            fatalError("Failed to fetch watch data: \(error)")
        }
    }
}
