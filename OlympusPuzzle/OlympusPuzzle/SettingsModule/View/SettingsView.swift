//
//  SettingsView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI
import AVFAudio

struct SettingsView: View {
    // MARK: - Property -
    @State private var player: AVAudioPlayer?
    @State private var musicVolume: Double = 0.5
    @State private var soundVolume: Double = 0.5
    
    // MARK: - Sounds tab -
    var soundsTab: some View {
        VStack {
            VStack(spacing: 25) {
                HStack {
                    Text(L10n.Settings.Title.music)
                        .font(.splineSansMonoBold(of: 30))
                        .foregroundColor(.cFFFFFF)
                    
                    Spacer()
                    
                    CustomSlider(
                        value: $musicVolume,
                        range: 0...1,
                        sliderHeight: 20,
                        gradientColorsFirst: [.c282729, .cEEEEEE, .c918D93, .c6C656D, .c282729],
                        gradientColorsSecond: [.c481571, .cCA33FF, .cA714CC, .c481571]
                    )
                    .onChange(of: musicVolume) { newValue in
                        AudioManager.shared.setMusicVolume(Float(newValue))
                    }
                    .padding(.leading, 33)
                }
                HStack {
                    Text(L10n.Settings.Title.sound)
                        .font(.splineSansMonoBold(of: 30))
                        .foregroundColor(.cFFFFFF)
                    
                    Spacer()
                    
                    CustomSlider(
                        value: $soundVolume,
                        range: 0...1,
                        sliderHeight: 20,
                        gradientColorsFirst: [.c282729, .cEEEEEE, .c918D93, .c6C656D, .c282729],
                        gradientColorsSecond: [.c481571, .cCA33FF, .cA714CC, .c481571]
                    )
                    .onChange(of: soundVolume) { newValue in
                        AudioManager.shared.setSoundEffectsVolume(Float(newValue))
                    }
                    .padding(.leading, 33)
                }
            }
            .padding(.vertical, 37)
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .background(Color.c092155.opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.top, 35)
    }
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Image(.settingsLogo)
                    .padding(.top, 140)
                
                soundsTab
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
        }
    }
}
#Preview {
    SettingsView()
}
