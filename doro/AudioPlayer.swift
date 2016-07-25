//
//  AudioPlayer.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
	var mySound: AVAudioPlayer?
	func setSound(fileName: String) {
		if let sound = self.setupAudioPlayerWithFile(fileName, type: "aif") {
			self.mySound = sound
		}
	}
	
	static let sharedSoundPlayer = AudioPlayer()
	
	func setupAudioPlayerWithFile(file: NSString, type: NSString) -> AVAudioPlayer? {
		let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
		let url = NSURL.fileURLWithPath(path!)
		var audioPlayer: AVAudioPlayer?
		do {
			try audioPlayer = AVAudioPlayer(contentsOfURL: url)
		} catch {
			print("Player not available")
		}
		return audioPlayer
	}

	func playSound() {
		mySound?.play()
	}
	func stopSound() {
		mySound?.stop()
	}
}
