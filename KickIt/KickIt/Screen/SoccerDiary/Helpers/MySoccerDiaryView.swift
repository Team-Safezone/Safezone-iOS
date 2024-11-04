//
//  MySoccerDiaryView.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import SwiftUI

struct MySoccerDiaryView: View {
    // MARK: - PROPERTY
    /// 축구 일기 객체
    @ObservedObject var viewModel: MySoccerDiaryViewModel
    
    /// 축구 일기 숨기기 이벤트
    var deleteDiaryAction: () -> Void
    
    /// 축구 일기 공유 바텀 시트
    @State private var isShowingShareSheet = false
    
    /// 공유할 축구 일기 이미지
    @State private var capturedDiaryImage: UIImage? = nil
    
    /// 공유할 축구 일기 이미지 사이즈
    @State private var captureSize: CGSize = .zero
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                // MARK: 사용자 정보
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
                        Text(viewModel.soccerDiary.isPublic ? "공개" : "비공개")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.white0)
                        Circle()
                            .frame(width: 2, height: 2)
                            .foregroundStyle(.gray500Text)
                        Text(viewModel.soccerDiary.diaryDate)
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500Text)
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
                    Button("삭제하기", role: .destructive) { viewModel.toggleDeleteDialog() }
                    Button("수정하기") { }
                    Button("공유하기") { captureImage() }
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
        } //: VSTACK
        .padding(.horizontal, 12)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        self.captureSize = geo.size // 일기의 실제 크기 저장
                    }
                    .frame(width: geo.size.width, height: geo.size.height) // 크기를 제한하여 부모 뷰와의 충돌 방지
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(
            "축구 일기 삭제",
            isPresented: $viewModel.showDeleteDialog
        ) {
            Button("삭제", role: .destructive) {
                // 축구 일기 삭제 API 호출
                viewModel.deleteDiaryEvent()
                
                // 삭제한 축구 일기 숨기기
                deleteDiaryAction()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("삭제하시면 다시 되돌릴 수 없어요\n정말 삭제하시겠습니까?")
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // 캡쳐된 이미지가 있을 경우 ShareLink 띄우기
            if let image = capturedDiaryImage {
                ShareLink(
                    item: Image(uiImage: image),
                    preview: SharePreview("Kick it 축구 일기", image: Image(uiImage: .miniGood))
                ) {
                    Label("축구 일기 공유하기", systemImage: "square.and.arrow.up")
                }
            }
            // 캡쳐된 이미지가 없을 경우
//                else {
//                    SnapshotView(content: self, captureSize: captureSize) { image in
//                        capturedDiaryImage = image // 캡처된 이미지 저장
//                    }
//                    .opacity(0) // 캡쳐된 이미지가 보이지 않도록 처리
//                }
        }
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
    
    /// 공유할 축구 일기 이미지화
    func captureImage() {
        let content = self // 현재 뷰를 캡처 대상으로 설정
        capturedDiaryImage = captureSnapshot(of: content, with: captureSize)
        isShowingShareSheet = true
    }
}

#Preview {
    MySoccerDiaryView(viewModel: MySoccerDiaryViewModel(diary: MyDiaryModel(diaryId: 1, teamUrl: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png", teamName: "토트넘", isPublic: true, diaryDate: "1시간", matchDate: stringToDateString("2024.11.03"), homeTeamName: "토트넘", homeTeamScore: 1, awayTeamName: "아스톤빌라", awayTeamScore: 2, emotion: .miniAngry, diaryContent: "항상 그렇지 뭐... 토트넘은 항상 똑같다. 대체 전술이 언제 바뀔까? 풀백이 공격수하는 이 이상한 전술은 언제까지 갖고 갈 것인지 의문이다. 아니 상대팀에 맞게 전술도 바꾸고 윙어랑 스트라이커 활용도 잘 해야지.. 무슨 풀백 의존도가 이런게 높은 축구를 대체 언제까지 봐야하나 싶다.", isLiked: false, likes: 1000)), deleteDiaryAction: { print("") })
}
