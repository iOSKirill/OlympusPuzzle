//
//  LaunchView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

struct LaunchView: View {
    // MARK: - Property -
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.logoName)
                    .padding(.horizontal, 16)
                    .offset(y: 60)
                
                Spacer()
                
                Image(.launchBottom)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    LaunchView()
}
