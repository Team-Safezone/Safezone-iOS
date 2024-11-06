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
            kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ] as [CFString: Any]
        
        let result: Bool = {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                print("Success create KeyChain")
                return true
            } else if status == errSecDuplicateItem {
                print("Success update KeyChain")
                return update(key: key, value: value)
            }
            
            print("KeyChain create Error")
            return false
        }()
            
        return result
    }
    
    // 값 가져오기
    func read(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service as Any,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as [CFString: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        else if status == errSecItemNotFound {
            print("Not Found \(key) in KeyChain")
            return nil
        }
        else {
            print("Error KeyChain: \(status.description)")
            return nil
        }
        return nil
    }
    
    // 값 업데이트
    func update(key: String, value: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as [CFString: Any]
        
        let attributes = [
            kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ] as [CFString: Any]
        
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
            kSecAttrAccount: key
        ] as [CFString: Any]
        
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
    /// jwt 토큰 추가
    func addJwtToken(token: String) -> Bool {
        KeyChain.shared.create(key: KeyChainKeys.jwtToken.rawValue, value: token)
    }
    
    /// jwt 토큰 가져오기
    func getJwtToken() -> String? {
        KeyChain.shared.read(key: KeyChainKeys.jwtToken.rawValue)
    }
    
    /// jwt 토큰 삭제
    func deleteJwtToken() -> Bool {
        KeyChain.shared.delete(key: KeyChainKeys.jwtToken.rawValue)
    }
    
    /// KeyChainKeys의 열거형을 사용한 아이템 추가
    func addKeyChainItem(key: KeyChainKeys, value: String) -> Bool {
        KeyChain.shared.create(key: key.rawValue, value: value)
    }
    
    /// KeyChainKeys의 열거형을 사용한 아이템 가져오기
    func getKeyChainItem(key: KeyChainKeys) -> String? {
        KeyChain.shared.read(key: key.rawValue)
    }
    
    /// KeyChainKeys의 열거형을 사용한 아이템 삭제
    func deleteKeyChainItem(key: KeyChainKeys) -> Bool {
        KeyChain.shared.delete(key: key.rawValue)
    }
    
    /// 카카오 회원탈퇴
    func deleteKakaoAccount() -> Bool {
        if delete(key: KeyChainKeys.kakaoNickname.rawValue) == false { return false }
        if delete(key: KeyChainKeys.kakaoEmail.rawValue) == false { return false }
        if deleteJwtToken() == false { return false }
        
        return true
    }
}
