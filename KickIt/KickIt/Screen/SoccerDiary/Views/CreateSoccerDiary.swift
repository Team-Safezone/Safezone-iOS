//
//  CreateSoccerDiary.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import SwiftUI

/// 축구 일기 작성 화면
struct CreateSoccerDiary: View {
    // MARK: - PROPERTY
    /// 1번 뒤로가기
    let popToOne: () -> Void
    
    /// 2번 뒤로가기
    let popToTwo: () -> Void
    
    /// 선택한 경기 정보
    let match: SelectSoccerMatch
    
    /// 뒤로가기 여부
    let isOneBack: Bool
    
    /// 뷰모델
    @StateObject private var viewModel: CreateSoccerDiaryViewModel
    
    /// 사용자가 선택한 팀
    @State private var selectedTeam: String? = nil
    
    /// 선택한 감정
    @State private var selectedEmotion: Int = -1
    
    /// 작성한 일기
    @State private var diaryContent: String = ""
    
    /// 선택한 이미지 리스트
    @State private var selectedPhotos: [DiaryPhotoItem] = []
    
    /// MOM
    @State private var mom: String = ""
    
    /// 공유 여부
    @State private var isPublic: Bool = true
    
    /// 최대 일기 작성 글자 수
    let limitDiaryCount = 500
    
    /// 최대 이미지 선택 가능 개수
    let maxImageLimit: Int = 5
    
    /// 사진 버튼을 눌렀는지에 대한 여부
    @State private var isAddingPhoto: Bool = false
    
    /// 일기 작성중 경고 팝업
    @State private var isShowCloseAlert: Bool = false
    
    init(popToOne: @escaping () -> Void, popToTwo: @escaping () -> Void, match: SelectSoccerMatch, isOneBack: Bool) {
        self.popToOne = popToOne
        self.popToTwo = popToTwo
        self.match = match
        self.isOneBack = isOneBack
        _viewModel = StateObject(wrappedValue: CreateSoccerDiaryViewModel(matchId: match.id))
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: - 네비게이션 바
                ZStack {
                    // 중앙에 위치한 텍스트
                    Text("새로운 축구 일기")
                        .font(.pretendard(.semibold, size: 16))
                        .foregroundStyle(.white0)
                    
                    // 닫기 버튼
                    HStack {
                        // 닫기 버튼
                        Button {
                            // 작성한 일기가 있다면
                            if selectedTeam != nil || selectedEmotion != -1 || !diaryContent.isEmpty {
                                isShowCloseAlert.toggle()
                            }
                            // 작성한 일기가 없다면
                            else {
                                // 화면 뒤로가기
                                handleNavigation()
                            }
                        } label: {
                            Image(uiImage: .back)
                                .foregroundStyle(.white0)
                        }
                        .padding(.leading, -12)
                        
                        Spacer() // 오른쪽으로 공간 밀어내기
                        
                        // MARK: 경기 작성 or 수정 버튼
                        if isOneBack {
                            Text("수정")
                                .pretendardTextStyle(.Title2Style)
                                .foregroundStyle(.limeText)
                                .padding(.trailing, 16)
                        }
                        else {
                            Button {
                                // 조건에 만족하면 축구 일기 작성 API 호출
                                createDiary()
                            } label: {
                                Text("작성")
                                    .pretendardTextStyle(.Title2Style)
                                    .foregroundStyle(validateCreateDiary() ? .limeText : .gray500Text)
                                    .padding(.trailing, 16)
                            }
                            .disabled(!validateCreateDiary())
                        }
                    }
                    .padding(.leading) // 버튼을 좌측에 고정시키기 위해 여백 조정
                }
                
                // MARK: - 경기 정보
                selectedMatchInfo()
                
                // MARK: - 나의 팀 프로필
                Text("나의 팀 프로필")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                // MARK: 나의 팀 프로필 선택 버튼
                HStack(spacing: 12) {
                    // 홈팀 팬 선택 버튼
                    teamButton(
                        teamName: match.homeTeamName,
                        emblemURL: match.homeTeamEmblemURL,
                        isSelected: selectedTeam == match.homeTeamName
                    )
                    
                    // 원정팀 팬 선택 버튼
                    teamButton(
                        teamName: match.awayTeamName,
                        emblemURL: match.awayTeamEmblemURL,
                        isSelected: selectedTeam == match.awayTeamName
                    )
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                // MARK: - 내 기분
                Text("내 기분")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                // MARK: 감정 버튼 리스트
                HStack {
                    ForEach(emotions, id: \.id) { emotion in
                        Button {
                            selectedEmotion = emotion.id
                        } label: {
                            VStack(spacing: 2) {
                                Image(uiImage: selectedEmotion == emotion.id ? emotion.selectedImg : emotion.defaultImg)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                Text(emotion.name)
                                    .pretendardTextStyle(.Body3Style)
                                    .foregroundStyle(selectedEmotion == emotion.id ? .white0 :.gray500Text)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                // 구분선
                Rectangle()
                    .fill(.gray950Assets)
                    .frame(height: 4)
                    .padding(.top, 16)
                
                // MARK: 일기 작성 텍스트 필드
                ZStack(alignment: .topLeading) {
                    KeyboardTextEditor(text: $diaryContent, textCount: $viewModel.diaryContentCount, accessoryView: {
                        HStack {
                            // MARK: 이미지 첨부 버튼
                            Button {
                                // 추가한 이미지가 5개 이하라면
                                if selectedPhotos.count < maxImageLimit {
                                    isAddingPhoto = true
                                }
                            } label: {
                                Image(uiImage: .photoCamera)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.white0)
                            }
                            
                            Spacer()
                            
                            Text("\(viewModel.diaryContentCount)자/\(limitDiaryCount)자")
                                .pretendardTextStyle(.Body3Style)
                                .foregroundStyle(.gray500Text)
                                .onAppear {
                                        print("Text appeared with count: \(diaryContent.count)")
                                    print("Text appeared with count22: \(viewModel.diaryContentCount)")
                                    }
                                    .onChange(of: diaryContent) { old, newValue in
                                        print("Text updated with new count: \(newValue.count)")
                                    }
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                        .background(Color.gray950)
                        .cardShadow()
                    })
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.white0)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, 10)
                    .padding(.horizontal, 24)
                    
                    if diaryContent.isEmpty {
                        Text("경기에 대한 일기를 남겨보세요")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.gray500Text)
                            .padding(.top, 10)
                            .padding(.horizontal, 24)
                    }
                }
                
                // MARK: 사용자가 선택한 이미지 리스트
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(selectedPhotos) { item in
                            Image(uiImage: item.photo)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay {
                                    // 이미지 삭제 버튼 띄우기
                                    Button {
                                        withAnimation {
                                            selectedPhotos.removeAll { $0.id == item.id }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 18))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .gray600)
                                    }
                                    .offset(x: 37, y: -37) // 버튼 위치 조정
                                    .frame(alignment: .topTrailing) // 이미지의 우측 상단에 배치
                                }
                                .padding([.top, .trailing], 12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.never)
                
                // 구분선
                Rectangle()
                    .fill(.gray950)
                    .frame(height: 1)
                    .padding(.top, 16)
                
                // MARK: MOM 작성 텍스트 필드
                HStack(spacing: 10) {
                    Text("MOM")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.white0)
                    TextField("내가 생각한 이번 경기의 최우수 선수는?(선택)", text: $mom)
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.white0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // 구분선
                Rectangle()
                    .fill(.gray950)
                    .frame(height: 1)
                    .padding(.top, 16)
                
                // MARK: 일기 공유 여부
                Button {
                    withAnimation {
                        isPublic.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(uiImage: .checkSquare)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isPublic ? .lime : .gray500Text)
                        Text("모든 사람에게 공유하기")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.white0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .navigationBarBackButtonHidden()
        // MARK: 사진 추가 시트 띄우기
        .sheet(isPresented: $isAddingPhoto) {
            PhotoPicker(selectedPhotos: $selectedPhotos)
        }
        // MARK: 일기 작성 중 경고 팝업 띄우기
        .alert(
            "축구 일기 작성중",
            isPresented: $isShowCloseAlert
        ) {
            Button("취소", role: .cancel) { }
                            
            Button("삭제", role: .destructive) { handleNavigation() }
        } message: {
            Text("지금 돌아가면 작성된 내용이\n모두 삭제됩니다.")
        }
    }
    
    // MARK: - FUNCTION
    /// 네비게이션 로직
    private func handleNavigation() {
        if isOneBack {
            popToOne()
        } else {
            popToTwo()
        }
    }
    
    /// 사용자가 선택한 경기 정보
    @ViewBuilder
    private func selectedMatchInfo() -> some View {
        HStack {
            HStack(spacing: 8) {
                Text(dateToString2(date: match.matchDate))
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
                
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: 1, height: 15)
                    .foregroundStyle(.gray800)
                
                HStack(spacing: 0) {
                    Text("\(match.homeTeamName) \(convertScore(score: match.homeTeamScore ?? -1))")
                        .foregroundStyle(.white0)
                    Text(" VS ")
                        .foregroundStyle(.gray500Text)
                    Text("\(convertScore(score: match.awayTeamScore ?? -1)) \(match.awayTeamName)")
                        .foregroundStyle(.white0)
                }
                .pretendardTextStyle(.SubTitleStyle)
            }
            
            Spacer()
            
            // 심박수 데이터가 있다면
            if let heart = viewModel.highHeartRate {
                HStack(spacing: 2) {
                    Text("최고")
                        .foregroundStyle(.gray500Text)
                    Text("\(heart)")
                        .foregroundStyle(.white0)
                    Text("BPM")
                        .foregroundStyle(.gray500Text)
                }
                .pretendardTextStyle(.Body2Style)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.gray950Assets)
    }
    
    /// 나의 팀 프로필 선택 이벤트 뷰
    @ViewBuilder
    private func teamButton(teamName: String, emblemURL: String, isSelected: Bool) -> some View {
        Button {
            // 클릭 이벤트 처리
            if selectedTeam == teamName {
                selectedTeam = nil // 이미 선택된 경우 해제
            } else {
                selectedTeam = teamName // 선택 상태로 변경
            }
        } label: {
            HStack(spacing: 3) {
                LoadableImage(image: emblemURL)
                    .frame(width: 20, height: 20)
                Text("\(teamName) 팬")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    isSelected ? Color.gray950 : Color.background
                )
                .stroke(
                    isSelected ? Color.lime : Color.gray800Btn,
                    style: StrokeStyle(lineWidth: 1)
                )
        )
    }
    
    /// 점수를 string으로 바꾸는 함수
    private func convertScore(score: Int) -> String {
        if score != -1 {
            return "\(score)"
        }
        else {
            return "-"
        }
    }
    
    /// 일기 작성&수정 버튼 클릭 가능 여부
    private func validateCreateDiary() -> Bool {
        return selectedTeam != nil && selectedEmotion != -1 && !diaryContent.isEmpty
    }
    
    /// 사용자가 선택한 이미지들을 API에 전송할 데이터 형태로 바꾸는 함수
    private func convertSelectedImageData() -> [MultipartFormFile] {
        selectedPhotos.enumerated().compactMap { index, image -> MultipartFormFile? in
            guard let data = image.photo.pngData() else { return nil }
            return MultipartFormFile(
                diaryPhotos: "diaryPhotos[\(index)]",
                fileName: "photo\(index + 1).png",
                mimeType: "image/png",
                data: data
            )
        }
    }
    
    /// 일기 작성 API 호출
    private func createDiary() {
        viewModel.createSoccerDiary(
            request: CreateSoccerDiaryRequest(
                matchId: match.id,
                teamName: selectedTeam ?? "",
                emotion: selectedEmotion,
                diaryContent: diaryContent,
                isPublic: isPublic
            ),
            files: convertSelectedImageData()
        ) { success in
            print(success ? "일기 작성 성공!" : "일기 작성 실패..")
            handleNavigation()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CreateSoccerDiary(popToOne: {}, popToTwo: {}, match: dummySelectSoccerMatch, isOneBack: false)
}
