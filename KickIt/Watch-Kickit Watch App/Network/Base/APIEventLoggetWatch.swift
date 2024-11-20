//
//  APIEventLogger.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 9/22/24.
//

import Foundation
import Alamofire

/// API 로그 출력하기
class APIEventLogger: EventMonitor {
    /// 모든 이벤트를 저장하는 큐
    let queue = DispatchQueue(label: "NetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        print("🛰 WATCH NETWORK Reqeust LOG")
        print(request.description)
        
        print("1️⃣ URL\n")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("2️⃣ Authorization\n")
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("3️⃣ Body\n")
        print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? "Body가 없습니다."))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        
        switch response.result {
        case .success(_):
            print("4️⃣ 서버 연결 성공")
        case .failure(_):
            print("4️⃣ 서버 연결 실패")
            print("URL을 확인해보세요.")
        }
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
        )
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 400..<500:
                print("⚠️ 오류: RequestError - 잘못된 요청입니다. Request를 재작성 해주세요.")
            case 500:
                print("⚠️ 오류: ServerError - Server에 문제가 발생했습니다.")
            default:
                break
            }
        }
        
        print("Data: \(response.data?.toPrettyPrintedString ?? "⚠️ 데이터가 없거나, Encoding에 실패했습니다.")")
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
