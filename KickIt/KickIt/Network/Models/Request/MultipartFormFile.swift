//
//  MultipartFormFile.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation

/// 파일 데이터 전송을 위한 Multipart 모델
struct MultipartFormFile {
    let diaryPhotos: String // 필드 이름
    let fileName: String // 파일 이름
    let mimeType: String // MIME 타입
    let data: Data // 파일 데이터
}
