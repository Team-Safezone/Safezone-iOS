//
//  NetworkResult.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 서버 통신 결과를 핸들링하기 위한 열거형
enum NetworkResult<T> {
    /// 성공
    case success(T)
    
    /// 요청 에러
    case requestErr(T)
    
    /// 경로 에러
    case pathErr
    
    /// 서버 내부 에러
    case serverErr
    
    /// 네트워크 연결 실패
    case networkFail
}

/// Combine 에러 결과를 핸들링하기 이한 열거형
enum NetworkError: Error {
    case requestError(Any)
    case pathError
    case serverError
    case networkFail
    case invalidResponse
}
