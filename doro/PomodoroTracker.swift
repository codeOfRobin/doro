//
//  PomodoroTracker.swift
//  doro
//
//  Created by Vmock on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import RealmSwift

enum PomodoroState {
	case HasntStarted,
	Success,
	Failure,
	Work,
	Break
}

protocol PomodoroTrackerDelegate {
	func pomodoroDidChangeState()
}

class PomodoroTracker: Object{
	
	var state: PomodoroState = .HasntStarted {
		didSet {
			print(state)
		}
	}
	
	// TODO: check if this can be a lazy var
	var workStartTime = NSDate()
	
	var workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)
	
	var breakStartTime = NSDate()
	
	var breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)
	
	var delegate: PomodoroTrackerDelegate?
	
	static let sharedPomodoroTracker = PomodoroTracker()
	
	var timeLeft: NSTimeInterval {
		switch state {
		case .Work:
			let workFinishTime = NSDate(timeInterval: workTimeInterval, sinceDate: workStartTime)
			let components = NSCalendar.currentCalendar().components(.Second, fromDate: NSDate(), toDate: workFinishTime, options: [])
			return NSTimeInterval(components.second)
		case .Break:
			let breakFinishTime = NSDate(timeInterval: breakTimeInterval, sinceDate: breakStartTime)
			let components = NSCalendar.currentCalendar().components(.Second, fromDate: NSDate(), toDate: breakFinishTime, options: [])
			return NSTimeInterval(components.second)
		default:
			return workTimeInterval
		}

	}
	
	var prettyPrintedTimeLeft: String {
		if timeLeft < 0
		{
			return "00:00"
		}
		var minutes = "\(Int(timeLeft/60))"
		var seconds = "\(Int(timeLeft%60))"
		if timeLeft/60 < 10 {
			minutes = "0" + minutes
		}
		if timeLeft%60 < 10 {
			seconds = "0" + seconds
		}
		return "\(minutes):\(seconds)"
	}
	
	func startWork() {
		state = .Work
		workStartTime = NSDate()
		let notification = UILocalNotification()
		notification.alertBody = "Your Work period is over. Time to take a break"
		notification.alertTitle = "Break Time!"
		notification.fireDate = NSDate(timeIntervalSinceNow: timeLeft)
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
	
	func startbreak() {
		state = .Break
		breakStartTime = NSDate()
	}
	
	func reinitPomodoro() {
		//TODO: DRY up this code and the property inits as well
		state = .HasntStarted
		workStartTime = NSDate()
		workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)
		breakStartTime = NSDate()
		breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)
	}
	
	func affirmativeTransition() {
		if state == .Work {
			state = .Break
			startbreak()
		}
		else if state == .Break {
			state = .Work
			startWork()
		}
		else {
			fatalError("You're not supposed to do an affirmativeTransition() from a non work or non Break state")
		}
	}
	
	
	
	func saveToDB() {
		let realm = try! Realm()
		try! realm.write {
			realm.add(self)
		}
	}
}

