//
//  AudioManager.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import AVFoundation

class AudioManager {
    // MARK: - Property -
    static let shared = AudioManager()
    
    var musicPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    // Initialization
    private init() { }
    
    // Play music
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else {
            print("Background music file not found.")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1 // Loop indefinitely
            musicPlayer?.volume = 0.5 // Default volume
            musicPlayer?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
    // Set volume music
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
    }

    // Play sound
    func playSoundEffect() {
        guard let url = Bundle.main.url(forResource: "soundEffect", withExtension: "mp3") else {
            print("Sound effect file not found.")
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.volume = 0.5 // Default volume
            soundPlayer?.play()
        } catch {
            print("Error playing sound effect: \(error.localizedDescription)")
        }
    }
    
    // Set volume sound
    func setSoundEffectsVolume(_ volume: Float) {
        soundPlayer?.volume = volume
    }
}
