//
//  SettingsViewController.swift
//  doro
//
//  Created by Vmock on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBAction func saveSettings(sender: AnyObject) {
		NSUserDefaults.standardUserDefaults().setValue(workTimePicker.countDownDuration, forKey: "workTimeInterval")
		NSUserDefaults.standardUserDefaults().setValue(breakTimePicker.countDownDuration, forKey: "breakTimeInterval")
		PomodoroTracker.sharedPomodoroTracker.workTimeInterval = workTimePicker.countDownDuration
		PomodoroTracker.sharedPomodoroTracker.breakTimeInterval = workTimePicker.countDownDuration
		self.dismissViewControllerAnimated(true) { 
		}
	}
	
	@IBAction func cancelButton(sender: AnyObject) {
		self.dismissViewControllerAnimated(true) {
		}
	}
	
	@IBOutlet weak var workTimePicker: UIDatePicker!
	@IBOutlet weak var breakTimePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
		//TODO: Make white should be a global function
		workTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
		breakTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
	workTimePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
		breakTimePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
		workTimePicker.timeZone =  NSTimeZone(abbreviation: "UTC")
		breakTimePicker.timeZone =  NSTimeZone(abbreviation: "UTC")
		workTimePicker.countDownDuration = 1500
		breakTimePicker.countDownDuration = 300
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
