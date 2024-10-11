//
//  TermsOfService.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 서비스 이용약관 화면
struct TermsOfService: View {
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
        Text("서비스 이용약관")
            .pretendardTextStyle(.Title1Style)
        }.navigationTitle("서비스 이용약관")
    }
}

#Preview {
    TermsOfService()
}
