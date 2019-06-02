//
//  Sound.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    private static let sharedSoundManager = SoundManager()
    
    class func shared() -> SoundManager {
        return sharedSoundManager
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        
        // stop any previous sounds
        player?.stop()
        
        guard let url = Bundle.main.url(forResource: "Lightsaber", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
