//
//  PrivacyPolicy.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 개인정보 처리방침 화면
struct PrivacyPolicy: View {
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            Text("개인정보 처리방침")
                .pretendardTextStyle(.Title1Style)
        }.navigationTitle("개인정보 처리방침")
    }
}

#Preview {
    PrivacyPolicy()
}
