//
//  SelectSoccerDiaryMatch.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import SwiftUI

/// 축구 일기를 작성할 경기를 선택할 수 있는 화면
struct SelectSoccerDiaryMatch: View {
    // MARK: - PROPERTY
    /// 1번 뒤로가기
    let popToOne: () -> Void
    
    /// 뷰모델
    @StateObject private var viewModel = SelectSoccerDiaryMatchViewModel()
    
    /// 현재 선택한 날짜
    @State private var currentDate: Date = Date()
    
    /// 현재 선택 중인 월 index
    @State private var currentMonth: Int = 0 // default 0
    
    /// 사용자가 선택한 경기 id
    @State private var selectedMatchId: Int64? = nil
    
    /// 사용자가 선택한 경기 정보
    @State private var selectedMatch: SelectSoccerMatch? = nil
    
    /// 요일 리스트
    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    /// 이전 달 경기 일정 조회 클릭 여부
    @State private var isPreviousMonth: Bool = false
    
    /// 다음 달 경기 일정 조회 클릭 여부
    @State private var isNextMonth: Bool = false
    
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
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.white0)
                    
                    HStack {
                        // 닫기 버튼
                        Button {
                            popToOne()
                        } label: {
                            Image(uiImage: .close)
                                .foregroundStyle(.white0)
                        }
                        .padding(.leading, -12)
                        
                        Spacer() // 오른쪽으로 공간 밀어내기
                        
                        // MARK: 경기 선택 버튼
                        // 선택한 경기가 있다면, 일기 작성 화면으로 이동
                        if selectedMatchId != nil {
                            if let selectedMatch = selectedMatch {
                                NavigationLink(value: NavigationDestination.createSoccerDiary(data: CreateSoccerDiaryNVData(match: selectedMatch, isOneBack: false))) {
                                    Text("선택")
                                        .pretendardTextStyle(.Title2Style)
                                        .foregroundStyle(.limeText)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        else {
                            Text("선택")
                                .pretendardTextStyle(.Title2Style)
                                .foregroundColor(.gray500Text)
                                .padding(.trailing, 16)
                                .disabled(true) // 선택 버튼 비활성화
                        }
                    }
                    .padding(.leading) // 버튼을 좌측에 고정시키기 위해 여백 조정
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: 타이틀
                    VStack(alignment: .leading, spacing: 4) {
                        Text("경기 선택")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        Text("기록하고 싶은 경기를 선택해주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500Text)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    
                    // MARK: 구분선
                    Rectangle()
                        .foregroundStyle(.gray900Assets)
                        .frame(height: 1)
                        .padding(.vertical, 14)
                    
                    // MARK: - 월 정보
                    HStack(alignment: .center, spacing: 20) {
                        // MARK: 이전 월로 변경하는 버튼
                        Button {
                            withAnimation {
                                currentMonth -= 1
                                
                                // 이전 월에 경기 리스트가 있다면 API 호출
                                if viewModel.isLeftExist {
                                    isPreviousMonth.toggle()
                                }
                                // 경기 리스트가 없다면
                                else {
                                    viewModel.matches = []
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.pretendard(.medium, size: 18))
                                .foregroundStyle(.gray500)
                        }
                        
                        // MARK: 현재 월 정보
                        Text("\(extractMonth())월")
                            .font(.pretendard(.medium, size: 18))
                            .foregroundStyle(.white0)
                        
                        // MARK: 다음 월로 변경하는 버튼
                        Button {
                            withAnimation {
                                currentMonth += 1
                                
                                // 다음 월에 경기 리스트가 있다면 API 호출
                                if viewModel.isRightExist {
                                    isNextMonth.toggle()
                                }
                                // 경기 리스트가 없다면
                                else {
                                    viewModel.matches = []
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.pretendard(.medium, size: 18))
                                .foregroundStyle(.gray500)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                    
                    // MARK: - 프리미어리그 팀 리스트
                    ScrollView(.horizontal) {
                        RadioButtonGroup(
                            // 팀 리스트 띄우기
                            items: viewModel.soccerTeamNames,
                            padding: 8,
                            selectedId: $viewModel.selectedRadioBtnID,
                            selectedTeamName: $viewModel.selectedTeamName,
                            callback: { previous, current, teamName in
                                // 팀 선택
                                viewModel.selectedTeam(teamName, id: current)
                                
                                // 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회
                                getSelectSoccerDiaryMatches()
                            }
                        )
                        .frame(height: 32)
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 16)
                    .scrollIndicators(.never)
                    
                    // MARK: - 일정 리스트
                    ScrollView {
                        if viewModel.matches.isEmpty {
                            Text("진행된 경기가 없습니다.")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.gray500Text)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 140)
                        }
                        else {
                            // matchDate를 기준으로 그룹화
                            let groupedMatches = Dictionary(grouping: viewModel.matches) { match in
                                dateToString2(date: match.matchDate)
                            }
                            
                            // matchDate 기준 정렬
                            let sortedGroupedMatches = groupedMatches.sorted { $0.key > $1.key } // 최신 날짜가 상단에 오도록 정렬
                            
                            ForEach(sortedGroupedMatches, id: \.key) { date, matches in
                                // 날짜
                                Text(date)
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.white0)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 5)
                                
                                // 경기 리스트
                                ForEach(matches, id: \.id) { match in
                                    SelectSoccerMatchView(match: match)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    selectedMatchId == match.id ? Color.lime : Color.gray900,
                                                    style: StrokeStyle(lineWidth: 1)
                                                )
                                        }
                                        .onTapGesture {
                                            // 클릭 이벤트 처리
                                            if selectedMatchId == match.id {
                                                selectedMatchId = nil // 이미 선택된 경우 해제
                                                selectedMatch = nil
                                            } else {
                                                selectedMatchId = match.id // 선택 상태로 변경
                                                selectedMatch = match
                                            }
                                            print("경기 선택! \(String(describing: selectedMatchId))")
                                        }
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .scrollIndicators(.never)
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
        // 월이 바뀌면 현재 선택 중인 날짜도 변경
        .onChange(of: currentMonth) { preDate, newDate in
            currentDate = currentMonthDates()
            
            // 이전 월 또는 다음 월에 경기 리스트가 있다면 API 호출
            if isPreviousMonth || isNextMonth {
                isPreviousMonth = false
                isNextMonth = false
                getSelectSoccerDiaryMatches()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - FUNCTION
    /// 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회
    private func getSelectSoccerDiaryMatches() {
        // 팀 이름 변환
        viewModel.setSelectedTeamName(teamName: viewModel.selectedTeamName)
        
        viewModel.getSelectSoccerDiaryMatch(
            query: SoccerMatchMonthlyRequest(yearMonth: dateToString5(
                date: currentDate),
                teamName: viewModel.selectedTeamName
            )
        )
    }
    
    /// 현재 날짜 정보를 문자열로 반환하는 함수
    private func extractMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        
        let date = formatter.string(from: currentDate)
        return date
    }
    
    /// 현재 월 정보를 반환하는 함수
    private func currentMonthDates() -> Date {
        // 현재 선택 중인 월 계산
        guard let currentMonth = Calendar.current.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date() // 계산된 날짜가 없는 경우
        }
        
        return currentMonth
    }
}

// MARK: - PREVIEW
#Preview {
    SelectSoccerDiaryMatch(popToOne: {})
}
