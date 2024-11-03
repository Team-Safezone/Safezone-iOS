//
//  SoccerDiaryNotifyBottomSheetView.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import SwiftUI

/// 신고하기 바텀시트
struct SoccerDiaryNotifyBottomSheetView: View {
    /// 축구 일기 객체
    @ObservedObject var viewModel: SoccerDiaryDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("이 글을 신고하는 이유를 알려주세요")
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
            
            CircleRadioGroup(
                items: viewModel.reasons,
                selectedId: $viewModel.reasonCode,
                selectedOption: $viewModel.selectedReason,
                callback: { prev, cur, option in
                    // 신고 이유 선택
                    viewModel.selectedReason(cur)
                }
            )
            
            Button {
                print("아이디: \(viewModel.soccerDiary.diaryId) | 이유: \(viewModel.reasonCode) 신고하기")
                viewModel.showNotifyDialog = false
            } label: {
                DesignWideButton(label: "신고하기", labelColor: .blackAssets, btnBGColor: .lime)
            }
        }
        .padding(.horizontal, 16)
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}
