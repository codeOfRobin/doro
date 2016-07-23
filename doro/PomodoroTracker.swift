//
//  PomodoroTracker.swift
//  doro
//
//  Created by Vmock on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import Foundation
import RealmSwift

enum PomodoroState {
	case HasntStarted,
	Success,
	Failure,
	Work,
	Break
}

class PomodoroTracker: Object{
	var state: PomodoroState = .HasntStarted
	var workStartTime = NSDate()
	var workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)
	var breakStartTime = NSDate()
	var breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)
	static let sharedPomodoroTracker = PomodoroTracker()
	
	func startWork(for minutes: Int?) {
		state = .Work
		workStartTime = NSDate()
		if let minutes = minutes {
			breakTimeInterval = NSTimeInterval(minutes)
		}
		print("Start Working")
	}
	// TODO: DRY up code below here
	func startbreak(for minutes: Int?) {
		state = .Break
		breakStartTime = NSDate()
		if let minutes = minutes {
			breakTimeInterval = NSTimeInterval(minutes)
		}
	}
	func reinitPomodoro() {
		//TODO: DRY up this code and the property inits as well
		state = .HasntStarted
		workStartTime = NSDate()
		workTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("workTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 25*60)
		breakStartTime = NSDate()
		breakTimeInterval = NSUserDefaults.standardUserDefaults().valueForKey("breakTimeInterval") as? NSTimeInterval ?? NSTimeInterval(integerLiteral: 5*60)
	}
	func saveToDB() {
		let realm = try! Realm()
		try! realm.write {
			realm.add(self)
		}
	}
}

