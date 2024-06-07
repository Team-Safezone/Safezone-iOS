//
//  KickItApp.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

@main
struct KickItApp: App {
    var body: some Scene {
        WindowGroup {
//            SplashView()
            HeartRate(dataPoints: [50, 70, 63, 117, 83, 150, 120, 133], dataTime: [17, 22, 23, 32, 35, 46, 58, 72])
        }
    }
}
