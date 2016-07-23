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
		print(workTimePicker.date)
		print(breakTimePicker.date)
	}
	
	@IBAction func cancelButton(sender: AnyObject) {
		
	}
	
	@IBOutlet weak var workTimePicker: UIDatePicker!
	@IBOutlet weak var breakTimePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
		workTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
		breakTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
	workTimePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
		breakTimePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
		workTimePicker.timeZone =  NSTimeZone(abbreviation: "UTC")
		breakTimePicker.timeZone =  NSTimeZone(abbreviation: "UTC")
		PomodoroTracker.sharedPomodoroTracker.reinitPomodoro()
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
