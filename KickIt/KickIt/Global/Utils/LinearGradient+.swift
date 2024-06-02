//
//  LinearGradient+.swift
//  KickIt
//
//  Created by 이윤지 on 6/2/24.
//

import Foundation
import SwiftUI

/// LinearGradient 확장 함수
extension LinearGradient {
    static let limeGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [.lime, Color.green]), startPoint: .top, endPoint: .bottom)
    static let pinkGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 87/255, blue: 188/255), Color(red: 246/255, green: 101/255, blue: 20/255)]), startPoint: .top, endPoint: .bottom)
    static let purpleGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 88/255, blue: 88/255), Color(red: 193/255, green: 15/255, blue: 255/255)]), startPoint: .top, endPoint: .bottom)
    static let blueGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 91/255, green: 95/255, blue: 252/255), .violet]), startPoint: .top, endPoint: .bottom)
}
