//
//  NewTipPercentageViewController.swift
//  TipCalc2
//
//  Created by Emmanuel Parasirakis on 1/9/16.
//  Copyright © 2016 Manny Parasirakis. All rights reserved.
//

import UIKit

class NewTipPercentageViewController: UIViewController {

    var tipModel:TipModel = TipModel.sharedInstance

    @IBOutlet weak var newTipField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func handleSubmitButton(sender: AnyObject) {
        let newPct = Double(newTipField.text!)
        tipModel.addTipPercentage(newPct!/100)
        
        self.navigationController?.popViewControllerAnimated(true)
        //self.dismissViewControllerAnimated(true, completion: {}) // use if show modal
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
