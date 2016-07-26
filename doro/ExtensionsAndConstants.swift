//
//  ExtensionsAndConstants.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

/// Shows a popover alert with the specified title and message
public func showAlert(title: String, message: String, presentingVC: UIViewController) {
	let alert = UIAlertController(
		title: title,
		message: message,
		preferredStyle: UIAlertControllerStyle.Alert
	)
	let ok = UIAlertAction(
		title: "OK",
		style: UIAlertActionStyle.Default,
		handler: nil
	)
	alert.addAction(ok)
	presentingVC.presentViewController(alert, animated: true, completion: nil)
}

/// A failure alert is a special case where the user hasn't provided Affirmative input. Encapsulated in a special function because it is called in multiple places
public func showFailureAlert(in presentingVC: UIViewController) {
	showAlert("Whoops", message: "Looks Like you didn't respond in time. Pomodoro Failed", presentingVC: presentingVC)
}

/// The sound name
var currentSoundName = "sound0.aif"

///generates the sound names
let toneNames = [0, 1, 2, 3].map {
	return "sound\($0)"
}

///Another really cool swift feature: *extend* system classes without subclassing. Set fonts w/o subclassing unlike the Android plebs.
extension Array {
	func randomItem() -> Element {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
}
