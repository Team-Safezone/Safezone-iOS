//
//  SetupAlertsViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import Foundation

// 알람 설정 뷰모델
class SetupAlertsViewModel: ObservableObject {
    @Published var isGameStartAlertOn: Bool = false
    @Published var isLineupAlertOn: Bool = false
    
    func toggleGameStartAlert() {
        isGameStartAlertOn.toggle()
        // 알림 설정 로직
    }
    
    func toggleLineupAlert() {
        isLineupAlertOn.toggle()
        // 알림 설정 로직
    }
}
