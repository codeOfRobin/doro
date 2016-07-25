//
//  ExtensionsAndConstants.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

func showAlert(title : String, message: String, presentingVC: UIViewController) {
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