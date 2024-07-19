//
//  AppButton.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI

struct AppButton<Destination: View>: View {
    // MARK: - Property -
    var image: ImageResource
    var destination: Destination
    
    // MARK: - Body -
    var body: some View {
        NavigationLink(destination: destination) {
            Image(image)
        }
    }
}

#Preview {
    AppButton(image: .playButton, destination: EmptyView())
}
