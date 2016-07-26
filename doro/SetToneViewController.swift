//
//  SetToneViewController.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

class SetToneViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var songPickerView: UIPickerView!

	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return toneNames.count
	}

	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return toneNames[row]
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		AudioPlayer.sharedSoundPlayer.stopSound()
		AudioPlayer.sharedSoundPlayer.setSound("sound\(row)")
		AudioPlayer.sharedSoundPlayer.playSound()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		songPickerView.dataSource = self
		songPickerView.delegate = self
        // Do any additional setup after loading the view.
    }

	@IBAction func saveSound(sender: AnyObject) {
		AudioPlayer.sharedSoundPlayer.stopSound()
		currentSoundName = toneNames[songPickerView.selectedRowInComponent(0)]
		AudioPlayer.sharedSoundPlayer.setSound(currentSoundName)
		self.dismissViewControllerAnimated(true) {
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	//TODO: Make sure there's one line at the end and in the beginning in every class
}
