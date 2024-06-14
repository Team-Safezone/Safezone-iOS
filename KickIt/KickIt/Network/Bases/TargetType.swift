//
//  TargetType.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Alamofire

/// Endpoint에 해당하는 Router들이 TargetType을 채택하여 Request 과정을 모듈화하도록 함
/// API 요청을 정의, URLRequestConvertible을 준수하여 URL 요청을 생성함
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get } // 기본 url
    var method: HTTPMethod { get } // HTTP 메서드
    var endPoint: String { get } // API의 endpoint
    var parameters: RequestParams { get } // 요청 parameter
    var header: HeaderType { get } // 요청 header
    var multipart: MultipartFormData { get } // mutipart 데이터
}

/// API 요청 시 parameter 정의
enum RequestParams {
    /// URL 쿼리
    case query(_ query: [String : Any])
    
    /// URL 쿼리 & Body Parameter
    case queryBody(_ query: [String : Any], _ body: [String : Any])
    
    /// 요청 Body Parameter
    case requestBody(_ body: [String : Any])
    
    /// 매개변수가 없는 경우(주로 get에서 사용)
    case requestPlain
}

extension TargetType {
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var multipart: MultipartFormData {
         return MultipartFormData()
    }
    
    /// URL 요청 생성
    func asURLRequest() throws -> URLRequest {
        // ?를 인코딩할 수 있는 형태로 변경
        let url = try (baseURL + endPoint).encodeURL()?.asURL()
        
        var urlRequest = try URLRequest(url: url!, method: method)
        
        // header 설정
        urlRequest = self.makeHeaderForRequest(to: urlRequest)
        
        // parameter 설정
        return try self.makeParameterForRequest(to: urlRequest, with: url!)
    }
    
    /// API 요청 시 header 설정
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        var request = request
        
        switch header {
        case .basic:
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .auth:
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(ContentType.tokenSerial.rawValue, forHTTPHeaderField: HTTPHeaderField.accesstoken.rawValue)
            
        case .multiPart:
            request.setValue(ContentType.multiPart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .multiPartWithAuth:
            request.setValue(ContentType.multiPart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(ContentType.tokenSerial.rawValue, forHTTPHeaderField: HTTPHeaderField.accesstoken.rawValue)
        
        case .headers(let headers):
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    /// API 요청 시 body 및 paremeter 설정
    private func makeParameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch parameters {
        case .query(let query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(endPoint).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .queryBody(let query, let body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(endPoint).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestBody(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        case .requestPlain:
            break
        }
        
        return request
    }
}
