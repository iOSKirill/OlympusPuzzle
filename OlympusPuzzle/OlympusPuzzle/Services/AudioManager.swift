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
    private init() { 
        loadVolumeSettings()
    }
    
    // Play music
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else {
            print("Background music file not found.")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1 // Loop indefinitely
            musicPlayer?.volume = UserDefaults.standard.float(forKey: "musicVolume")
            musicPlayer?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
    // Set volume music
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
        UserDefaults.standard.set(volume, forKey: "musicVolume")
    }

    // Play sound
    func playSoundEffect() {
        guard let url = Bundle.main.url(forResource: "soundEffect", withExtension: "mp3") else {
            print("Sound effect file not found.")
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.volume = UserDefaults.standard.float(forKey: "soundEffectsVolume")
            soundPlayer?.play()
        } catch {
            print("Error playing sound effect: \(error.localizedDescription)")
        }
    }
    
    // Set volume sound
    func setSoundEffectsVolume(_ volume: Float) {
        soundPlayer?.volume = volume
        UserDefaults.standard.set(volume, forKey: "soundEffectsVolume")
    }
    
    // Load volume settings from UserDefaults
    private func loadVolumeSettings() {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "musicVolume") == nil {
            defaults.set(0.5, forKey: "musicVolume")
        }
        if defaults.value(forKey: "soundEffectsVolume") == nil {
            defaults.set(0.5, forKey: "soundEffectsVolume")
        }
    }
}
