//
//  NetworkResult.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 에러 결과를 핸들링하기 위한 열거형
enum NetworkError: Error {
    /// 요청 에러
    case requestErr(String)
    
    /// 디코딩 실패
    case pathErr
    
    /// auth 인증 실패
    case authFailed
    
    /// 서버 내부 에러
    case serverErr(String)
    
    /// 네트워크 연결 실패
    case networkFail(String)
    
    /// 알 수 없는 오류
    case unknown(String)
}
