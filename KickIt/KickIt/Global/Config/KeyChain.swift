//
//  KeyChain.swift
//  KickIt
//
//  Created by 이윤지 on 9/2/24.
//

import Foundation
import Security

class KeyChain {
    /// KeyChain 전역 객체
    static let shared = KeyChain()
    
    // 서비스 이름
    private let service = Bundle.main.bundleIdentifier
    
    // 값 추가
    func create(key: String, value: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service as Any,
            kSecValueData: value.data(using: .utf8) as Any
        ] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("KeyChain create Error")
            return false
        }
        print("Success create KeyChain")
        return true
    }
    
    // 값 가져오기
    func read(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service as Any,

            kSecValueData: true
        ] as [String: Any]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            return String(data: item as! Data, encoding: .utf8)
        }
        else if status == errSecItemNotFound {
            print("Not Found \(key) in KeyChain")
            return nil
        }
        else {
            print("Error KeyChain: \(status.description)")
            return nil
        }
    }
    
    // 값 업데이트
    func update(key: String, value: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword
        ] as [String: Any]
        
        let attributes = [
            kSecAttrService: service as Any,
            kSecAttrAccount: key,
            kSecValueData: value.data(using: .utf8) as Any
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            print("Not Fount \(key) in KeyChain")
            return false
        }
        guard status == errSecSuccess else {
            print("Error update KeyChain")
            return false
        }
        print("Success update KeyChain")
        return true
    }
    
    // 값 삭제
    func delete(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as Any,
            kSecAttrAccount: key
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecItemNotFound else {
            print("Not Fount \(key) in KeyChain")
            return false
        }
        guard status == errSecSuccess else {
            print("Error delete KeyChain")
            return false
        }
        print("Success delete KeyChain")
        return true
    }
}

/// 키체인 확장 함수
extension KeyChain {
    // jwt 토큰 추가
    func addJwtToken(token: String) -> Bool {
        KeyChain.shared.create(key: KeyChainKeys.jwtToken.rawValue, value: token)
    }
    
    // jwt 토큰 가져오기
    func getJwtToken() -> String? {
        KeyChain.shared.read(key: KeyChainKeys.jwtToken.rawValue)
    }
    
    // jwt 토큰 삭제
    func deleteJwtToken() -> Bool {
        KeyChain.shared.delete(key: KeyChainKeys.jwtToken.rawValue)
    }
}
