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
//            HeartRate()
            TimelineEvent(events: PlayEvents)
        }
    }
}
