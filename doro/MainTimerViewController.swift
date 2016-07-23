//
//  MainTimerViewController.swift
//  doro
//
//  Created by Robin on 23/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

class MainTimerViewController: UIViewController {
	
	override func viewDidAppear(animated: Bool) {
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let grad = CAGradientLayer()
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
