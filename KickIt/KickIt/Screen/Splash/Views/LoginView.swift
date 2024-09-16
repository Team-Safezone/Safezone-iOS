//
//  LoginView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 로그인 화면
struct LoginView: View {
    var body: some View {
        NavigationStack{
            ZStack(alignment: .leading){
                Image("login_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading)
                {
                    VStack(alignment: .leading)
                    {
                        Spacer()
                        VStack(alignment: .leading, spacing: 5){
                            Text("지금 로그인하고, 축구를 보며")
                                .font(.pretendard(.medium, size: 20))
                            Text("두근거렸던 순간을 확인해보세요!")
                                .font(.pretendard(.bold, size: 20))
                        } //:VSTACK
                        .padding(.bottom, 63)
                        
                        // Apple로 로그인
                        NavigationLink{
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .foregroundStyle(.gray900)
                                .overlay{
                                    HStack(alignment: .center, spacing: 88){
                                        Image("apple_logo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 17, height: 17)
                                            .padding(.leading, 16)
                                        Text("Apple로 로그인")
                                            .pretendardTextStyle(.Body1Style)
                                            .foregroundStyle(.white0)
                                            .padding(.leading, 12)
                                        Spacer()
                                    }
                                }
                        }
                        .padding(.bottom, 10)
                        
                        // 네이버로 로그인
                        NavigationLink{
                            SettingNameView()
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .foregroundStyle(.gray900)
                                .overlay{
                                    HStack(alignment: .center, spacing: 88){
                                        Image("naver_logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .padding(.leading, 16)
                                        Text("네이버로 로그인")
                                            .pretendardTextStyle(.Body1Style)
                                            .foregroundStyle(.white0)
                                            .padding(.leading, 12)
                                        Spacer()
                                    }
                                }
                        }//:NAVIGATIONLINK
                        .padding(.bottom, 96)
                        
                    } //:VSTACK
                }.padding(.horizontal, 16) //:VSTACK
            }//:ZSTACK
        }//:NAVIGATIONSTACK
    }
}

#Preview {
    LoginView()
}
