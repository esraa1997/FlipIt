//
//  MusicHelper.swift
//  FlipIt
//
//  Created by Sandra Soliman on 8/8/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import AVFoundation

class MusicHelper {
		static let sharedHelper = MusicHelper()
		var audioPlayer: AVAudioPlayer?
		
		func playBackgroundMusic() {
			let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Beats-bongo", ofType: "mp3")!)
			do {
				audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
				audioPlayer!.numberOfLoops = -1
				audioPlayer!.prepareToPlay()
				audioPlayer!.play()
				audioPlayer?.volume = 0.1
			} catch {
				print("Cannot play the file")
			}
		}
	}


