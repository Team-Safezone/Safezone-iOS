//
//  User.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import Foundation

struct User {
    let minHeartRate: Int
    let avgHeartRate: Int
    let maxHeartRate: Int
    
    static let currentUser = User(minHeartRate: 45, avgHeartRate: 75, maxHeartRate: 120)
}
