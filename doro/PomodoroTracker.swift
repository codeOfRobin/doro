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
	Play
}

class PomodoroTracker: Object{
	var state: PomodoroState = .HasntStarted
	var workStartTime = NSDate()
	var workTimeInterval = NSTimeInterval(integerLiteral: 25*60)
	var playStartTime = NSDate()
	var playTimeInterval = NSTimeInterval(integerLiteral: 5*60)
	static let sharedPomodoroTracker = PomodoroTracker()
	
	func startWork(for minutes: Int?) {
		state = .Work
		workStartTime = NSDate()
		if let minutes = minutes {
			workTimeInterval = NSTimeInterval(minutes)
		}
		print("Start Working")
	}
	// TODO: DRY up code below here
	func startPlay(for minutes: Int?) {
		state = .Play
		playStartTime = NSDate()
		if let minutes = minutes {
			playTimeInterval = NSTimeInterval(minutes)
		}
	}
	
	func reinitPomodoro() {
		state = .HasntStarted
		workStartTime = NSDate()
		workTimeInterval = NSTimeInterval(integerLiteral: 25*60)
		playStartTime = NSDate()
		playTimeInterval = NSTimeInterval(integerLiteral: 5*60)
	}
	func saveToDB() {
		let realm = try! Realm()
		try! realm.write {
			realm.add(self)
		}
	}
}

