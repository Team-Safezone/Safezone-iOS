//
//  DeleteAccountViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import Foundation

// 로그아웃, 회원 탈퇴 뷰모델
class ManageAccountViewModel: ObservableObject {
    @Published var showingDeleteAlert = false
    @Published var showingLogoutAlert = false
    
    
    // 로그아웃
    func logoutAccount() {
        // 예: APIService.shared.logout()
        print("Log out")
    }
    
    // 회원 탈퇴
    func deleteAccount() {
        
        print("Delete Account")
    }
}
