//
//  LoginView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 로그인 화면
struct LoginView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.background.ignoresSafeArea()
            
            Image("login_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(alignment: .leading)  {
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
                    
                    // 카카오로 로그인
                    Button(action: {
                        viewModel.nextStep()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .foregroundStyle(.kakao)
                            .overlay {
                                HStack(alignment: .center, spacing: 88) {
                                    Image("kakao_logo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 16)
                                    Text("카카오로 로그인")
                                        .pretendardTextStyle(.Body1Style)
                                        .foregroundStyle(.black0)
                                        .padding(.leading, 12)
                                    Spacer()
                                }
                            }
                    }
                }
                .padding(.bottom, 10)
                
                // 네이버로 로그인
                Button(action: {
                    viewModel.nextStep()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .foregroundStyle(.white0)
                        .overlay {
                            HStack(alignment: .center, spacing: 88) {
                                Image("apple_logo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .padding(.leading, 16)
                                Text("Apple로 로그인")
                                    .pretendardTextStyle(.Body1Style)
                                    .foregroundStyle(.black0)
                                    .padding(.leading, 12)
                                Spacer()
                            }
                        }
                }
                .padding(.bottom, 96)
            }
            .padding(.horizontal, 16)
        }.environment(\.colorScheme, .dark) // 무조건 다크모드
    }
}

#Preview {
    LoginView(viewModel: MainViewModel())
}
