//
//  LoadableImage.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import SwiftUI

/// 비동기적으로 url 이미지를 불러오는 이미지 뷰
struct LoadableImage: View {
    /// 서버에서 전달받은 이미지 URL
    let image: String
    
    var body: some View {
        // MARK: 비동기적으로 이미지 로드
        let imageURL = URL(string: image)
        AsyncImage(url: imageURL) { phase in
            // 이미지 로드를 성공했다면
            if let loadImage = phase.image {
                loadImage
                    .resizable()
                    .scaledToFit()
            }
            // 이미지 로드를 실패했다면
            else if phase.error != nil {
                Circle()
                    .fill(.gray500)
            }
            // 로딩 애니메이션 띄우기
            else {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg")
}
