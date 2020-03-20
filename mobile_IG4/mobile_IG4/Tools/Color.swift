//
//  Color.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 20/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
