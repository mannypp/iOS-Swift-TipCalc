//
//  ViewController.swift
//  TipCalc2
//
//  Created by Emmanuel Parasirakis on 12/19/15.
//  Copyright © 2015 Manny Parasirakis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var taxPercentage: UISlider!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var output: UITextView!
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearPercentagesButton: UIButton!
    @IBOutlet weak var editPercentagesButton: UIButton!
    
    var tipModel:TipModel = TipModel.sharedInstance
    var actualTaxPercent:Double = 0.0
    var lastResult:Dictionary<Int, (tipAmt:Double, totalAmt:Double)> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (tipModel.getPercentagesCount() == 0) {
            tipModel.seedPercentages()
        }
        
        tipModel.loadPercentages()

        taxAmountLabel.text = "Tax Amount (\(Int(taxPercentage.value * 100))%)"
        actualTaxPercent = Double(taxPercentage.value)
        
        tableView.separatorStyle = .SingleLine
        tableView.layer.borderWidth = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        if (totalAmount.text == "") {
            return
        }
        
        recalculate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        taxAmountLabel.text = "Tax Amount (\(Int(taxPercentage.value * 100))%)"
        actualTaxPercent = Double(taxPercentage.value)
    }
    
    @IBAction func calculate(sender: AnyObject) {
        if (totalAmount.text == "") {
            showAlert("Please enter an amount")
            return
        }
        
        recalculate()
    }
    
    @IBAction func clearAllPercentages(sender: AnyObject) {
        tipModel.deleteAllPercentages()
        tipModel.seedPercentages()
        tipModel.loadPercentages()
        recalculate()
    }
    
    func recalculate() {
        let result = tipModel.calculate(Double(totalAmount.text!)!, taxAmount: actualTaxPercent)
        lastResult = result
        output.text = ""
        
        for tip in tipModel.getTipPercentages() {
            let tipInt = Int(tip * 100)
            let value = lastResult[tipInt]
            let totalWithTip = Double(totalAmount.text!)! + value!.tipAmt
            let out = NSString(format: "%.2f%%: $%.2f ($%.2f)\n", tip * 100, value!.tipAmt, totalWithTip)
            output.text?.appendContentsOf(out as String)
        }
        
        tableView.reloadData()
    }
    
    func showAlert(message:String) {
        let alertController = UIAlertController(title: "Tip Calulator", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipModel.getTipPercentages().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if (lastResult.count == 0) {
            return cell
        }
        
        let tip = tipModel.getTipPercentages()[indexPath.row]
        let tipInt = Int(tip * 100)
        let value = lastResult[tipInt]
        let totalWithTip = Double(totalAmount.text!)! + value!.tipAmt
        let out = NSString(format: "%.2f%%: $%.2f ($%.2f)", tip * 100, value!.tipAmt, totalWithTip)
        
        cell.textLabel?.text = out as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tipModel.removeElementAt(indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.endUpdates()
        }
    }
    @IBAction func editPercentagesTable(sender: AnyObject) {
        tableView.setEditing(!tableView.editing, animated: true)
        self.parentViewController?.editButtonItem().enabled = !tableView.editing
        editPercentagesButton.setTitle(tableView.editing ? "Done" : "Edit", forState: UIControlState.Normal)
    }
}

