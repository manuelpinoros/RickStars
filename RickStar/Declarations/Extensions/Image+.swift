//
//  Image.swift
//  EscapeSounds
//
//  Created by Manuel Pino Ros on 27/2/25.
//
import SwiftUI

extension Image {
    init(systemName: String, fallbackAssetName: String) {
        if let _ = UIImage(systemName: systemName) {
            self = Image(systemName: systemName)
                .renderingMode(.template)
        } else {
            self = Image(fallbackAssetName)
                .renderingMode(.template)
        }
    }
}
