//
//  APISecrets.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

extension Bundle {
    var baseURL: String {
        // plist 파일 경로 불러오기
        guard let file = self.path(forResource: "Secrets", ofType: "plist")
        else {
            fatalError("Secrets.plist 경로 불러오기 실패")
        }
        
        // plist를 딕셔너리로 받기
        guard let resource = NSDictionary(contentsOfFile: file)
        else {
            fatalError("Secrets.plist 딕셔너리로 받기 실패")
        }
        
        // 딕셔너리에서 값 찾기
        guard let url = resource["BASE_URL"] as? String
        else {
            fatalError("Secrets.plist에 BASE_URL 설정 필요")
        }
        return url
    }
}
