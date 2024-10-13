//
//  DeleteAccount.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 탈퇴하기 화면
struct DeleteAccount: View {
    @StateObject private var viewModel = ManageAccountViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer()
                
                Image("delete")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80, alignment: .center)
                    .padding(.bottom, 30)
                
                Text("정말로 탈퇴하시겠습니까?")
                    .pretendardTextStyle(.Title1Style)
                    .padding(.bottom, 16)
                
                Text("회원 탈퇴를 원하시는 경우,\n계정 및 관련 정보가 삭제되며, 복구가 불가능합니다\n\n서비스 이용에 대한 모든 기록이 사라지니\n신중히 결정해 주세요")
                    .pretendardTextStyle(.Body2Style)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                DesignWideButton(label: "탈퇴하기", labelColor: .white0, btnBGColor: .gray900Assets)
                    .padding()
                    .onTapGesture {
                        viewModel.showingDeleteAlert = true
                    }
            }
        }
        .navigationTitle("회원 탈퇴")
        .alert(isPresented: $viewModel.showingDeleteAlert) {
            Alert(
                title: Text("탈퇴하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    viewModel.deleteAccount()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

#Preview {
    DeleteAccount()
}
