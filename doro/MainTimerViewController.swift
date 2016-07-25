
//
//  MainTimerViewController.swift
//  doro
//
//  Created by Robin on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import AVFoundation

class MainTimerViewController: UIViewController, PomodoroTrackerDelegate {
	
	@IBOutlet weak var timeLeft: UILabel!
	
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var primaryButton: UIButton!
	
	var grad = CAGradientLayer()
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if PomodoroTracker.sharedPomodoroTracker.state == .HasntStarted {
			timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
		}
	}
	
	
	// TODO: Put all the gradient colors etc in the constants folder
	func pomodoroDidChangeState() {
		
		switch PomodoroTracker.sharedPomodoroTracker.state {
		case .HasntStarted:
			grad.colors = [UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor, UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor]
			timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
			primaryButton.setTitle("Start", forState: .Normal)
			statusLabel.text = "Start Working?"
			
		case .Waiting:
			AudioPlayer.sharedSoundPlayer.playSound()
			grad.colors = [UIColor(red:0.88, green:0.38, blue:0.06, alpha:1.00).CGColor, UIColor(red:0.89, green:0.96, blue:0.08, alpha:1.00).CGColor, ]
			statusLabel.text = "Tap the button to continue"
			statusLabel.numberOfLines = 0
			statusLabel.sizeToFit()
			primaryButton.setTitle("Move to next Stage", forState: UIControlState.Normal)
			NSNotificationCenter.defaultCenter().addObserverForName("pomodoroFailed", object: nil, queue: nil, usingBlock: { (notification) in
				PomodoroTracker.sharedPomodoroTracker.reinitPomodoro()
				showFailureAlert(in: self)
				PomodoroTracker.sharedPomodoroTracker.abandonPomodoro()
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
			print("Success or failure state. Nothign to do here.")
		}
		
		let updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainTimerViewController.updateFunction(_:)), userInfo: nil, repeats: true)
		NSRunLoop.currentRunLoop().addTimer(updateTimer, forMode: NSRunLoopCommonModes)
	}
	
	
	@IBAction func mainButtonTapped(sender: UIButton) {
		switch PomodoroTracker.sharedPomodoroTracker.state {
		case .HasntStarted:
			PomodoroTracker.sharedPomodoroTracker.startWork()
		case .Work:
			PomodoroTracker.sharedPomodoroTracker.abandonPomodoro()
		case .Break:
			PomodoroTracker.sharedPomodoroTracker.abandonPomodoro()
		case .Waiting:
			AudioPlayer.sharedSoundPlayer.stopSound()
			if PomodoroTracker.sharedPomodoroTracker.prevState == .Work {
				PomodoroTracker.sharedPomodoroTracker.startbreak()
			}
			else {
				PomodoroTracker.sharedPomodoroTracker.successfulPomodoro()
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
		// TODO: Put all styling code into one function
		AudioPlayer.sharedSoundPlayer.setSound("sound1")
		primaryButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		primaryButton.layer.cornerRadius = 10
		primaryButton.sizeToFit()
		grad.frame = view.frame
		grad.colors = [UIColor(red:0.06, green:0.47, blue:0.88, alpha:1.00).CGColor, UIColor(red:0.16, green:0.78, blue:0.24, alpha:1.00).CGColor]
		grad.startPoint = CGPointMake(0.5, 0.4)
		view.layer.insertSublayer(grad, atIndex: 0)
		PomodoroTracker.sharedPomodoroTracker.delegate = self
		timeLeft.text = PomodoroTracker.sharedPomodoroTracker.prettyPrintedTimeLeft
		// Do any additional setup after loading the view.
	}
}
