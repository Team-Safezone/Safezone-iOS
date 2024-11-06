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
    case query(_ query: Encodable)
    
    /// URL 쿼리 & Body Parameter
    case queryBody(_ query: Encodable, _ body: Encodable)
    
    /// 요청 Body Parameter
    case requestBody(_ body: Encodable)
    
    /// 매개변수가 없는 경우(주로 get에서 사용)
    case requestPlain
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
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
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url, method: method)
        
        // header 설정
        urlRequest = self.makeHeaderForRequest(to: urlRequest)
        
        // parameter 설정
        return try self.makeParameterForRequest(to: urlRequest, with: url)
    }
    
    /// API 요청 시 header 설정
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        var request = request
        
        switch header {
        case .basic:
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .multiPart:
            request.setValue(ContentType.multiPart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        return request
    }
    
    /// API 요청 시 body 및 paremeter 설정
    private func makeParameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch parameters {
        case .query(let query):
            let params = query.toDictionary()
            // parameter 중 nil값 처리
            let queryParams = params.compactMap { (key, value) -> URLQueryItem? in
                if let stringValue = value as? String, !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                else if let longValue = value as? Int64 {
                    return URLQueryItem(name: key, value: String(longValue))
                }
                return nil
            }
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .queryBody(let query, let body):
            let params = query.toDictionary()
            // parameter 중 nil값 처리
            let queryParams = params.compactMap { (key, value) -> URLQueryItem? in
                if let stringValue = value as? String, !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                else if let longValue = value as? Int64 {
                    return URLQueryItem(name: key, value: String(longValue))
                }
                return nil
            }
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
            let bodyParams = body.toDictionary()
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
            
        case .requestBody(let body):
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            request.url = components?.url
            
            let bodyParams = body.toDictionary()
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        
        case .requestPlain:
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            request.url = components?.url
        }
        
        return request
    }
}
