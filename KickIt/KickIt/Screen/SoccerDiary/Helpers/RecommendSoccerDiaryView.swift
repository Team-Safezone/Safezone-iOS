//
//  RecommendSoccerDiaryView.swift
//  KickIt
//
//  Created by 이윤지 on 10/20/24.
//

import SwiftUI

/// 추천 일기 화면
struct RecommendSoccerDiaryView: View {
    // MARK: - PROPERTY
    /// 축구 일기 객체
    @ObservedObject var viewModel: RecommendSoccerDiaryViewModel
    
    /// 축구 일기 숨기기 이벤트
    var hideNotifyDiaryAction: () -> Void
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                // MARK: 사용자 정보
                HStack(spacing: 6) {
                    Image(uiImage: viewModel.soccerDiary.grade)
                        .resizable()
                        .frame(width: 38, height: 38)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 4) {
                            // MARK: 팀 이미지
                            LoadableImage(image: viewModel.soccerDiary.teamUrl)
                                .frame(width: 18, height: 18)
                            
                            Text("\(viewModel.soccerDiary.teamName) 팬")
                                .pretendardTextStyle(.Caption1Style)
                                .foregroundStyle(.limeText)
                        }
                        HStack(spacing: 4) {
                            Text(viewModel.soccerDiary.nickname)
                                .pretendardTextStyle(.SubTitleStyle)
                                .foregroundStyle(.white0)
                            Text(viewModel.soccerDiary.diaryDate)
                                .pretendardTextStyle(.Body2Style)
                                .foregroundStyle(.gray500Text)
                        }
                    }
                }
                
                Spacer()
                
                // MARK: 메뉴
                Button {
                    viewModel.toggleDialog()
                } label: {
                    Image(uiImage: .optionMenu)
                        .foregroundStyle(.gray300)
                }
                .confirmationDialog("", isPresented: $viewModel.showDialog) {
                    Button("신고하기", role: .destructive) { viewModel.toggleNotifyDialog() }
                    Button("공유하기") { }
                    Button("취소", role: .cancel) { }
                }
            }
            
            // MARK: 일기 내용
            diaryContent()
                .padding(.top, 10)
            
            // MARK: 좋아요
            HStack(spacing: 4) {
                // 좋아요 버튼
                Button {
                    // 좋아요 버튼 클릭 이벤트 API 호출
                    viewModel.toggleLike()
                } label: {
                    Image(uiImage: viewModel.soccerDiary.isLiked ? .like : .notLike)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                // 좋아요 횟수
                Text("\(viewModel.soccerDiary.likes)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 12)
        // MARK: 신고하기 바텀 시트
        .sheet(isPresented: $viewModel.showNotifyDialog) {
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
                    // 축구 일기 신고하기 API 호출
                    viewModel.notifyDiary()
                    
                    // 신고한 축구 일기 숨기기
                    hideNotifyDiaryAction()
                } label: {
                    DesignWideButton(label: "신고하기", labelColor: .blackAssets, btnBGColor: .lime)
                }
            }
            .padding(.horizontal, 16)
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(16)
            .presentationBackground(.gray950)
        } //: SHEET
    }
    
    // MARK: - FUNCTION
    /// 일기 내용
    @ViewBuilder
    private func diaryContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 4) {
                    // MARK: 경기 날짜
                    Text(viewModel.soccerDiary.matchDate)
                        .foregroundStyle(.gray300)
                    
                    // MARK: 경기 정보
                    Text("\(viewModel.soccerDiary.homeTeamName) \(viewModel.soccerDiary.homeTeamScore) VS \(viewModel.soccerDiary.awayTeamScore) \(viewModel.soccerDiary.awayTeamName)")
                        .foregroundStyle(.white0)
                }
                .pretendardTextStyle(.Body3Style)
                
                Spacer()
                
                HStack(spacing: 5) {
                    // MARK: 이모지
                    Image(uiImage: viewModel.soccerDiary.emotion)
                        .resizable()
                        .frame(width: 22, height: 22)
                    
                    // MARK: 최고 심박수
                    if let bpm = viewModel.soccerDiary.highHeartRate {
                        HStack(spacing: 2) {
                            Text("최고")
                                .foregroundStyle(.gray500Text)
                            Text("\(bpm)")
                                .foregroundStyle(.white0)
                            Text("BPM")
                                .foregroundStyle(.gray500Text)
                        }
                        .pretendardTextStyle(.Body3Style)
                    }
                }
            }
            .padding(.horizontal, 12)
            
            // 구분선
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.limeTransparent)
                .padding(.vertical, 10)
            
            // MARK: 일기 내용
            Text(viewModel.soccerDiary.diaryContent)
                .pretendardTextStyle(TextStyle(font: .pretendard(.regular, size: 14), tracking: -0.4, uiFont: UIFont(name: "Pretendard-Regular", size: 14)!, lineHeight: 20))
                .foregroundStyle(.gray50)
                .padding(.horizontal, 12)
            
            // MARK: 일기 사진
            if let images = viewModel.soccerDiary.diaryPhotos {
                // 사진이 1장이라면
                if images.count == 1 {
                    LoadableImage(image: images[images.startIndex])
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(.top, 8)
                        .padding(.horizontal, 10)
                }
                // 사진이 여러장이라면
                else {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                                LoadableImage(image: image)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .frame(height: 150)
                                    .padding(.leading, index == 0 ? 12 : 0) // 첫 번째 이미지에 왼쪽 여백
                                    .padding(.trailing, index == images.count - 1 ? 12 : 0) // 마지막 이미지에 오른쪽 여백
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    .padding(.top, 8)
                }
            }
            
            // MARK: MOM
            if let mom = viewModel.soccerDiary.mom {
                HStack(spacing: 4) {
                    Text("MOM")
                        .foregroundStyle(.gray500Text)
                    Text(mom)
                        .foregroundStyle(.gray300)
                }
                .pretendardTextStyle(.Body2Style)
                .padding(.top, 10)
                .padding(.horizontal, 12)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 15)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray950)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.limeTransparent, lineWidth: 1)
        )
    }
}

// MARK: - PREVIEW
#Preview("추천 일기 & 내 일기") {
    RecommendSoccerDiaryView(viewModel: RecommendSoccerDiaryViewModel(diary: RecommendDiaryModel(diaryId: 3, grade: .ball0, teamUrl: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", teamName: "맨시티", nickname: "닉네임", diaryDate: "3시간", matchDate: "2024.11.02", homeTeamName: "본머스", homeTeamScore: 2, awayTeamName: "맨시티", awayTeamScore: 1, emotion: .miniAngry, highHeartRate: 100, diaryContent: "오늘 울버햄튼과 뉴캐슬의 경기는 정말 손에 땀을 쥐게 하는 경기였다. 울버햄튼의 수비가 초반부터 뉴캐슬의 공격을 꽤 잘 막아냈지만, 결국 뉴캐슬의 빠른 역습에 무너지고 말았다. \n\n특히 뉴캐슬의 윌슨이 보여준 마무리 능력은 인상적이었다. 하지만 울버햄튼도 쉽게 물러나지 않았다. 후반전에 공격적인 전술로 전환하면서 트라오레의 돌파가 활기를 불어넣었고, 마침내 동점골을 만들어냈다. \n\n경기가 끝나기 직전, 양 팀 모두 결승골을 노리며 치열한 공방을 펼쳤지만, 결국 1-1로 마무리되었다.", diaryPhotos: ["https://dimg.donga.com/wps/NEWS/IMAGE/2024/10/21/130256053.1.jpg", "https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202304/09/990e5d5f-8fe7-4662-82f3-ea7a157f51f9.jpg", "https://flexible.img.hani.co.kr/flexible/normal/970/646/imgdb/original/2024/0211/20240211500449.jpg"], mom: "손흥민", isLiked: false, likes: 100)), hideNotifyDiaryAction: { print("") })
}
