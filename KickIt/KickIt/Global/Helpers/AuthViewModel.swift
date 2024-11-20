//
//  AuthViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 11/12/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    init() {
        updateAuthenticationStatus()
    }
    
    func updateAuthenticationStatus() {
        isAuthenticated = KeyChain.shared.getJwtToken() != nil
        print("[updateAuthenticationStatus] isAuthenticated = \(isAuthenticated)")
    }
    
    func login(with token: String) {
        KeyChain.shared.addJwtToken(token: token)
        isAuthenticated = true
        print("[login] isAuthenticated = \(isAuthenticated)")
    }
    
    func logout() {
        KeyChain.shared.deleteJwtToken()
        isAuthenticated = false
        print("[logout] isAuthenticated = \(isAuthenticated)")
    }
}
