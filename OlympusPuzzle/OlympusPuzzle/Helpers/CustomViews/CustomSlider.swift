//
//  CustomSlider.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI

struct CustomSlider: View {
    // MARK: - Property -
    @Binding var value: Double
    
    var range: ClosedRange<Double>
    var sliderHeight: CGFloat
    var gradientColorsFirst: [Color]
    var gradientColorsSecond: [Color]
    
    // MARK: - Body -
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                // Slider background
                LinearGradient(
                    gradient: Gradient(colors: gradientColorsFirst),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 14)
                .cornerRadius(sliderHeight / 2)
                
                // Slider fill
                LinearGradient(
                    gradient: Gradient(colors: gradientColorsSecond),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 14)
                .cornerRadius(sliderHeight / 2)
                
                // Draggable knob
                Image(.circle)
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - sliderHeight / 2)
                    .gesture(
                        DragGesture().onChanged { gesture in
                            let newValue = Double(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound) + range.lowerBound
                            if newValue >= range.lowerBound && newValue <= range.upperBound {
                                value = newValue
                            }
                        }
                    )
            }
        }
        .frame(height: sliderHeight)
    }
}
