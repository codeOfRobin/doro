
//
//  MainTimerViewController.swift
//  doro
//
//  Created by Robin on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

class MainTimerViewController: UIViewController, PomodoroTrackerDelegate {
	
	@IBOutlet weak var timeLeft: UILabel!
	
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var primaryButton: UIButton!
	
	var grad = CAGradientLayer()
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		PomodoroTracker.sharedPomodoroTracker.delegate = self
		timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
	}
	
	func pomodoroDidChangeState() {
		
		switch PomodoroTracker.sharedPomodoroTracker.state {
		case .HasntStarted:
			grad.colors = [UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor, UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor]
			timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
			primaryButton.setTitle("Start", forState: .Normal)
			statusLabel.text = "Start Working?"
			
		case .Waiting:
			grad.colors = [UIColor(red:0.88, green:0.38, blue:0.06, alpha:1.00).CGColor, UIColor(red:0.89, green:0.96, blue:0.08, alpha:1.00).CGColor, ]
			statusLabel.text = "Tap the button to continue"
			statusLabel.numberOfLines = 0
			statusLabel.sizeToFit()
			primaryButton.setTitle("Move to next Stage", forState: UIControlState.Normal)
			NSNotificationCenter.defaultCenter().addObserverForName("pomodoroFailed", object: nil, queue: nil, usingBlock: { (notification) in
				PomodoroTracker.sharedPomodoroTracker.reinitPomodoro()
				showAlert("Whoops", message: "Looks Like you didn't respond in time. Pomodoro Failed", presentingVC: self)
				// TODO: FAILURE CODE HERE
			})
			
		case .Break:
			grad.colors = [UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor, UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor]
			statusLabel.text = "Break"
			statusLabel.sizeToFit()
			primaryButton.setTitle("Abandon", forState: UIControlState.Normal)
			NSNotificationCenter.defaultCenter().addObserverForName("breakPeriodOver", object: nil, queue: nil, usingBlock: { (notification) in
				PomodoroTracker.sharedPomodoroTracker.startWaiting()
			})
		case .Work:
			grad.colors = [UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor, UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor]
			statusLabel.text = "Work"
			primaryButton.setTitle("Abandon", forState: UIControlState.Normal)
			NSNotificationCenter.defaultCenter().addObserverForName("workPeriodOver", object: nil, queue: nil, usingBlock: { (notification) in
				PomodoroTracker.sharedPomodoroTracker.startWaiting()
			})
		default:
			print("Not covered yet")
		}
		
		let updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainTimerViewController.updateFunction(_:)), userInfo: nil, repeats: true)
		NSRunLoop.currentRunLoop().addTimer(updateTimer, forMode: NSRunLoopCommonModes)
	}
	
	@IBAction func mainButtonTapped(sender: UIButton) {
		switch PomodoroTracker.sharedPomodoroTracker.state {
		case .HasntStarted:
			PomodoroTracker.sharedPomodoroTracker.startWork()
		case .Work:
			// TODO: Abandon function
			PomodoroTracker.sharedPomodoroTracker.reinitPomodoro()
		case .Break:
			// TODO: Abandon function
			PomodoroTracker.sharedPomodoroTracker.reinitPomodoro()
		case .Waiting:
			if PomodoroTracker.sharedPomodoroTracker.prevState == .Work {
				PomodoroTracker.sharedPomodoroTracker.startbreak()
			}
			else {
				// SAVE TO DB HERE.
				// TODO: SUCCESS CODE
//				PomodoroTracker.sharedPomodoroTracker.saveToDB()
			}
		case .Success:
			fatalError("A failure state is transient")
		case .Failure:
			fatalError("A failure state is transient")
		}
	}
	
	func updateFunction(sender: NSTimer) {
		timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		grad.frame = view.frame
		grad.colors = [UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor, UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor]
		grad.startPoint = CGPointMake(0.5, 0.4)
		view.layer.insertSublayer(grad, atIndex: 0)
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
