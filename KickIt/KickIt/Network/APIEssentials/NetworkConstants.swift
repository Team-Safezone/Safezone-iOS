//
//  NetworkConstants.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 모든 api 통신 과정에서 필요한 header 상수들을 관리하는 파일

/// API 요청 시, 헤더 유형을 정의하는 열거형
enum HeaderType {
    /// 기본, 추가 헤더 값이 없는 경우
    case basic
    
    /// 사용자 인증, 토큰 및 인증 헤더가 필요한 경우
    case auth
    
    /// 파일, 파일(이미지 등) 및 복합 데이터 전송이 필요한 경우
    case multiPart
    
    /// 파일&사용자 인증, 동시에 파일 업로드 및 사용자 인증이 필요한 경우
    case multiPartWithAuth
    
    /// 헤더, 추가 헤더 값을 넣는 경우
    case headers(headers: [String: String])
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case accesstoken = "accesstoken"
}

enum ContentType: String {
    case json = "Application/json"
    case tokenSerial = ""
    case multiPart = "multipart/form-data"
}
