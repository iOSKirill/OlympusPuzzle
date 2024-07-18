//
//  Font+Extension.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

extension SwiftUI.Font {
    static func markoOneRegular(of size: CGFloat) -> SwiftUI.Font {
        FontFamily.MarkoOne.regular.swiftUIFont(size: size)
    }
    
    static func splineSansMonoBold(of size: CGFloat) -> SwiftUI.Font {
        FontFamily.SplineSansMono.bold.swiftUIFont(size: size)
    }
    
    static func splineSansMonoMedium(of size: CGFloat) -> SwiftUI.Font {
        FontFamily.SplineSansMono.medium.swiftUIFont(size: size)
    }
    
    static func splineSansMonoRegular(of size: CGFloat) -> SwiftUI.Font {
        FontFamily.SplineSansMono.regular.swiftUIFont(size: size)
    }
}

