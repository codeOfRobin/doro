//
//  PomodoroTracker.swift
//  doro
//
//  Created by Vmock on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import RealmSwift


/// A set of states which the pomodoro can exist in
enum PomodoroState {
	/// HasntStarted: Before the user activates a work period
	case HasntStarted,
	/// Success: A pomodoro *cycle*, i.e a work period and a cycle were completed
	Success,
	/// Failure: Indicates a user has abandoned a pomodoro cycle
	Failure,
	/// Waiting: an intermediary state between a work-to-break or a break-to-work transition
	Waiting,
	/// A work period
	Work,
	/// A break period
	Break
}

/// A delegate to inform a viewController that the pomodoro has changed state
protocol PomodoroTrackerDelegate {
	func pomodoroDidChangeState()
}

/// The PomodoroTracker class. Responsible for anything the pomodoro does - time tracking, state transitions etc.
class PomodoroTracker: Object {

	/// The state of the pomodoro. It's an enum that activates the delegate method `pomodoroDidChangeState` everytime it runs
	var state: PomodoroState = .HasntStarted {
		didSet {
			delegate?.pomodoroDidChangeState()
		}
	}

	/// A property for the realm DB as realm doesn't support enums. Specifies Failure and/or Success states
	var wasSuccessfulOnDBSave = false

	/// Tracks the previous state of the pomodoro. Important when in the Waiting state so the pomodoro knows which one comes next
	var prevState: PomodoroState?

	/// The time when a work period starts
	var workStartTime = NSDate()

	/// The time interval of a work period
	var workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)

	/// The time when a break period starts
	var breakStartTime = NSDate()

	/// The time interval of a break period
	var breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)

	/// The time when a waiting period starts
	var waitingStartTime = NSDate()

	/// The time interval of a waiting period
	let waitingTimeInterval = NSTimeInterval(30)

	/// The delegate that 'listens' for a change in the Pomodoro state
	var delegate: PomodoroTrackerDelegate?

	/// Since this is a singleton
	static let sharedPomodoroTracker = PomodoroTracker()

	/// returns the timeLeft in any state. Never returns invalid negative times
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
		case .Waiting:
			let waitingFinishTime = NSDate(timeInterval: waitingTimeInterval, sinceDate: waitingStartTime)
			let components = NSCalendar.currentCalendar().components(.Second, fromDate: NSDate(), toDate: waitingFinishTime, options: [])
			return NSTimeInterval(components.second)
		default:
			return workTimeInterval
		}
	}

	/// Pretty printed time for the UILabel. This is a swift computed property
	var prettyPrintedTimeLeft: String {
		if timeLeft < 0 {
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

	/// Start a waiting period. Also starts a notification that gets posted in 30 seconds, failing the pomodoro if not necessary
	func startWaiting() {
		prevState = state
		state = .Waiting
		waitingStartTime = NSDate()
		let notification = UILocalNotification()
		notification.alertBody = "You didn't respond in time. Sorry! We've had to assume you've abandoned the Pomodoro"
		notification.alertTitle = "Whoops!"
		notification.fireDate = NSDate(timeIntervalSinceNow: timeLeft)
		notification.userInfo = ["broadcastName": "pomodoroFailed"]
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

	/// Starts a working period. Schedules a notification for when it ends so a waiting period can start
	func startWork() {
		state = .Work
		workStartTime = NSDate()
		let notification = UILocalNotification()
		notification.alertBody = "Your Work period is over. Time to take a break"
		notification.alertTitle = "Break Time!"
		notification.fireDate = NSDate(timeIntervalSinceNow: timeLeft)
		notification.userInfo = ["broadcastName" : "workPeriodOver"]
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

	/// Starts a break period. Schedules a notification for when it ends so a waiting period can start
	func startbreak() {
		state = .Break
		breakStartTime = NSDate()
		let notification = UILocalNotification()
		notification.alertBody = "Your Break period is over. Time to continue working"
		notification.alertTitle = "Work Time!"
		notification.fireDate = NSDate(timeIntervalSinceNow: timeLeft)
		notification.userInfo = ["broadcastName" : "breakPeriodOver"]
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

	/// reinitializes the pomodoro so it can be reused
	func reinitPomodoro() {
		//TODO: DRY up this code and the property inits as well
		state = .HasntStarted
		workStartTime = NSDate()
		workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)
		breakStartTime = NSDate()
		breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)
	}

	/// executed to register a successful pomodoro cycle
	func successfulPomodoro() {
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		state = .Success
		wasSuccessfulOnDBSave = true
		saveToDB()
		// FIXME: turn this into start work thing.
		reinitPomodoro()
	}

	/// executed to register a failed pomodoro cycle
	func abandonPomodoro() {
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		state = .Failure
		wasSuccessfulOnDBSave = false
		saveToDB()
	}

	/// Save to the Realm Database
	func saveToDB() {
		let realm = try! Realm()
		try! realm.write {
			realm.add(self)
			reinitPomodoro()
		}
	}
}
