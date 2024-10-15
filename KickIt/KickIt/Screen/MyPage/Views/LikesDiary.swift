//
//  LikesDiary.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 좋아요 한 축구 일기 화면
struct LikesDiary: View {
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            Text("좋아요한 축구 일기")
            
        }.navigationTitle("좋아요한 축구 일기")
    }
}

#Preview {
    LikesDiary()
}
