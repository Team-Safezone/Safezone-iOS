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
    /// 기본
    case basic
    
    /// 파일, 파일(이미지 등) 및 복합 데이터 전송이 필요한 경우
    case multiPart
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case accept = "Accept"
}

enum ContentType: String {
    case json = "application/json"
    case multiPart = "multipart/form-data; "
}
