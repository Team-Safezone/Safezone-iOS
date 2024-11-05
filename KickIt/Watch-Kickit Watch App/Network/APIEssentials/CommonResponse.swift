//
//  CommonResponse.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 11/5/24.
//

import Foundation

/// 공통 API 응답 모델
struct CommonResponse<T: Codable>: Codable {
    var status: Int
    var isSuccess: Bool
    var message: String
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case isSuccess = "isSuccess"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        isSuccess = (try? values.decode(Bool.self, forKey: .isSuccess)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decodeIfPresent(T.self, forKey: .data)) ?? nil
    }
}
