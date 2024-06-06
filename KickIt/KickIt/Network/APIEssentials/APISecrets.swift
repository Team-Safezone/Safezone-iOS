//
//  APISecrets.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

struct APISecrets: Codable {
    /// 서버 URL
    let baseURL: String
}

func loadSecrets() -> APISecrets? {
    guard let baseURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else { print("Secrets.plist 추적 실패")
        return nil }
    
    do {
        let data = try Data(contentsOf: baseURL)
        let decoder = PropertyListDecoder()
        let apiSecrets = try decoder.decode(APISecrets.self, from: data)
        return apiSecrets
    } catch {
        print("Secrets.plist decoding 오류")
        return nil
    }
}
