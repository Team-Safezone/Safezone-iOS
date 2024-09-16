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
    static let greenGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 49/255, green: 218/255, blue: 134/255), Color(red: 17/255, green: 162/255, blue: 149/255)]), startPoint: .top, endPoint: .bottom)
    static let pinkGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 137/255, blue: 95/255), Color(red: 252/255, green: 105/255, blue: 177/255)]), startPoint: .top, endPoint: .bottom)
    static let purpleGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 88/255, blue: 88/255), Color(red: 193/255, green: 15/255, blue: 255/255)]), startPoint: .top, endPoint: .bottom)
}
