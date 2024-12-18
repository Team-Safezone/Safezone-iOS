//
//  SoccerDiary.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 축구 경기 일기 화면
struct SoccerDiary: View {
    // MARK: - PROPERTY
    @State private var selectedTab: DiaryTabInfo = .recommend
    @Namespace private var animation
    
    /// 추천 축구 일기 새로고침 요청 횟수
    @State private var requestIndex: Int = 0
    
    /// 내 축구 일기 새로고침 요청 횟수
    @State private var myDiaryRequestIndex: Int = 0
    
    /// 경기 일기 뷰모델
    @StateObject private var viewModel = SoccerDiaryViewModel()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("축구 일기")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                
                // MARK: 상단 탭 바
                tabAnimate()
                
                // MARK: 축구 일기 리스트
                ScrollView {
                    VStack(spacing: 0) {
                        // 추천 일기
                        if (selectedTab == .recommend) {
                            ForEach(Array(viewModel.recommendDiarys.enumerated()), id: \.offset) { index, diaryVM in
                                RecommendSoccerDiaryView(viewModel: diaryVM, hideNotifyDiaryAction: {
                                    viewModel.hideNotifyDiary(diaryVM)
                                })
                                .padding(.vertical, 16)
                                
                                // 마지막 일기가 아닐 경우
                                if index < viewModel.recommendDiarys.count - 1 {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(.gray900)
                                }
                            }
                            
                            // 추천 축구 일기가 10개 이상이라면
                            if viewModel.recommendDiarys.count >= 10 {
                                // MARK: 추천 축구 일기 더보기 버튼
                                Button {
                                    requestIndex += 1
                                    viewModel.updateRequestNum(num: requestIndex)
                                    viewModel.getRecommendDiarys() // 일기 조회 api 호출
                                } label: {
                                    Text("일기 더보기")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.white0)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 15)
                                        .background(
                                            RoundedRectangle(cornerRadius: 100)
                                                .fill(.gray900)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .padding(.bottom, 10)
                            }
                        }
                        // 내 일기
                        else {
                            ForEach(Array(viewModel.myDiarys.enumerated()), id: \.offset) { index, diaryVM in
                                MySoccerDiaryView(viewModel: diaryVM, deleteDiaryAction: {
                                    viewModel.hideDeleteDiary(diaryVM)
                                })
                                .padding(.vertical, 16)
                                
                                // 마지막 일기가 아닐 경우
                                if index < viewModel.myDiarys.count - 1 {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(.gray900)
                                }
                            }
                            
                            // 내 일기가 10개 이상이라면
                            if viewModel.myDiarys.count >= 10 {
                                // MARK: 내 축구 일기 더보기 버튼
                                Button {
                                    myDiaryRequestIndex += 1
                                    viewModel.updateMyDiaryRequestNum(num: myDiaryRequestIndex)
                                    viewModel.getMyDiarys() // 내 일기 조회 api 호출
                                } label: {
                                    Text("일기 더보기")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.white0)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 15)
                                        .background(
                                            RoundedRectangle(cornerRadius: 100)
                                                .fill(.gray900)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                }
                .scrollIndicators(.never)
            }
            
            // MARK: 일기 추가 버튼
            NavigationLink(value: NavigationDestination.selectSoccerDiaryMatch) {
                Image(uiImage: .diaryPlus)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray900)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.limeFAB)
                    )
                    .defaultShadow()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 16)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - FUNCTION
    // 탭바 애니메이션
    @ViewBuilder
    private func tabAnimate() -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(DiaryTabInfo.allCases, id: \.self) { item in
                        VStack(spacing: 0) {
                            Text(item.rawValue)
                                .pretendardTextStyle(selectedTab == item ? .SubTitleStyle : .Body2Style)
                                .frame(maxWidth: .infinity/2, minHeight: 32, alignment: .center)
                                .foregroundStyle(selectedTab == item ? .white0 : .gray500Text)
                                .background(Color.background)
                            
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .foregroundStyle(Color.background)
                                    .frame(height: 1)
                                    .opacity(0)
                                    .background(.gray900Assets)
                                
                                if selectedTab == item {
                                    Rectangle()
                                        .foregroundStyle(.lime)
                                        .frame(width: selectedTab == DiaryTabInfo.recommend ? 25 : 40, height: 2)
                                        .matchedGeometryEffect(id: "info", in: animation)
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedTab = item
                            }
                            
                            if selectedTab == .my {
                                viewModel.getMyDiarys()
                            }
                            else {
                                viewModel.getRecommendDiarys()
                            }
                        }
                    }
                } //: HStack
            }
        } //: VStack
    }
}

/// 이미지 캡쳐
func captureSnapshot<Content: View>(of content: Content, with size: CGSize) -> UIImage? {
    let controller = UIHostingController(rootView: content)
    controller.view.bounds = CGRect(origin: .zero, size: size)
    controller.view.backgroundColor = .clear
    
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
}

// MARK: - PREVIEW
#Preview("일기") {
    SoccerDiary()
}
