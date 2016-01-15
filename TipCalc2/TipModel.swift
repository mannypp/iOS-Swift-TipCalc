//
//  TipModel.swift
//  TipCalc2
//
//  Created by Emmanuel Parasirakis on 12/19/15.
//  Copyright © 2015 Manny Parasirakis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TipModel {
    static let sharedInstance = TipModel()
    var tipPct:[Double] = [] //[0.15, 0.18, 0.20]

    init() {
    }
    
    func addTipPercentage(newPct:Double) {
        savePercentage(newPct)
    }
    
    func removeTipPercentage(pct:Double) {
        deletePercentage(pct)
    }
    
    func removeElementAt(location:Int) {
        removeTipPercentage(tipPct[location])
    }
    
    func removeAllTipPercentages() {
        deleteAllPercentages()
    }
    
    func getTipPercentages() -> [Double] {
        return tipPct
    }
    
    func calculate(totalAmount:Double, taxAmount:Double) -> Dictionary<Int, (tipAmt:Double, totalAmt:Double)> {
        var result = Dictionary<Int, (tipAmt:Double, totalAmt:Double)>()
        
        for tip in tipPct {
            let subtotal = totalAmount - (totalAmount * taxAmount)
            let tipAmt = subtotal * tip
            result[Int(tip*100)] = (tipAmt, subtotal)
        }
        
        return result
    }
    
    //---------------
    func getManagedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    func savePercentage(newPct:Double) {
        if (tipPct.contains(newPct)) {
            return
        }
        
        let moc = getManagedObjectContext()
        addEntityPercentage(newPct, moc: moc)
        tipPct.append(newPct)
        tipPct.sortInPlace()
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    func loadPercentages() {
        let moc = getManagedObjectContext()
        let percentageFetch = NSFetchRequest(entityName: "TipPercentage")
        
        do {
            let fetchedPercentage = try moc.executeFetchRequest(percentageFetch) as! [TipPercentage]
            for pct in fetchedPercentage {
                tipPct.append(pct.percentage! as Double)
            }
            tipPct.sortInPlace()
        } catch {
            fatalError("Failed to fetch percentage: \(error)")
        }
    }
    
    func getPercentagesCount() -> Int {
        let moc = getManagedObjectContext()
        let percentageFetch = NSFetchRequest(entityName: "TipPercentage")
        
        do {
            let fetchedPercentage = try moc.executeFetchRequest(percentageFetch) as! [TipPercentage]
            return fetchedPercentage.count
        } catch {
            fatalError("Failed to fetch percentage: \(error)")
        }
    }
    
    func deletePercentage(pctToDelete:Double) {
        let moc = getManagedObjectContext()
        let percentageFetch = NSFetchRequest(entityName: "TipPercentage")
        
        do {
            let fetchedPercentage = try moc.executeFetchRequest(percentageFetch) as! [TipPercentage]
            for pct in fetchedPercentage {
                let high = Double(pct.percentage!) + 0.001;
                let low = Double(pct.percentage!) - 0.001
                if (pctToDelete == pct.percentage || (pctToDelete < high && pctToDelete > low)) {
                    moc.deleteObject(pct)
                }
            }
            for(var i = 0; i < tipPct.count; i++) {
                if (tipPct[i] == pctToDelete) {
                    tipPct.removeAtIndex(i)
                }
            }

            try moc.save()
        } catch {
            fatalError("Failed to delete percentage: \(error)")
        }
    }
    
    func deleteAllPercentages() {
        let moc = getManagedObjectContext()
        let percentageFetch = NSFetchRequest(entityName: "TipPercentage")
        
        do {
            let fetchedPercentage = try moc.executeFetchRequest(percentageFetch) as! [TipPercentage]
            for pct in fetchedPercentage {
                moc.deleteObject(pct)
            }
            
            tipPct.removeAll()

            try moc.save()
        } catch {
            fatalError("Failed to delete percentage: \(error)")
        }
    }
    
    func seedPercentages() {
        let moc = getManagedObjectContext()
        
        addEntityPercentage(0.15, moc: moc)
        addEntityPercentage(0.18, moc: moc)
        addEntityPercentage(0.20, moc: moc)
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func addEntityPercentage(pct:Double, moc:NSManagedObjectContext) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("TipPercentage", inManagedObjectContext: moc) as! TipPercentage
        entity.setValue(pct, forKey: "percentage")
    }
    
    func addEntityWatchData(data:String, moc:NSManagedObjectContext) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("WatchData", inManagedObjectContext: moc) as! WatchData
        entity.setValue(data, forKey: "tipData")
    }
    
    func updateWatchData(data:String) {
        let moc = getManagedObjectContext()
        let watchDataFetch = NSFetchRequest(entityName: "WatchData")
        
        do {
            let fetchedWatchData = try moc.executeFetchRequest(watchDataFetch) as! [WatchData]
            if (fetchedWatchData.count == 0) {
                addEntityWatchData(data, moc)
            }
            else {
                fetchedWatchData[0].setValue(data, forKey:"tipData")
            }

            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}