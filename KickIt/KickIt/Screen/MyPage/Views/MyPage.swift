//
//  MyPage.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import SwiftUI

/// 마이페이지 화면
struct MyPage: View {
    @StateObject private var viewModel = MyPageViewModel()
    @StateObject private var mnviewModel = ManageAccountViewModel()
    
    var body: some View {
        NavigationStack {
                ZStack {
                    Color.background.ignoresSafeArea()
                    ScrollView(showsIndicators: false){
                    VStack(alignment: .leading, spacing: 20) {
                        Text("마이페이지")
                            .pretendardTextStyle(.Title1Style)
                            .foregroundStyle(.white0)
                        
                        profileSection
                        gradeSection
                        myTeamSection
                        menuList
                        accountActions
                        Spacer()
                    }.padding(.horizontal, 16)
                }
            }
        }
        .tint(.white0)
        .alert(isPresented: $viewModel.showingLogoutAlert) {
            Alert(
                title: Text("로그아웃하시겠습니까?"),
                primaryButton: .destructive(Text("확인"), action: mnviewModel.logoutAccount),
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
    
    // 프로필
    private var profileSection: some View {
        HStack(spacing: 9){
            Image("ball\(viewModel.getIndexForBallLevel(viewModel.currentBallLevel.name)!)")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 0){
                Text(viewModel.nickname)
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(Color.white0)
                Text(viewModel.email)
                    .foregroundStyle(.gray500Text)
                    .pretendardTextStyle(.Body2Style)
            }
            Spacer()
            NavigationLink(destination: MyProfile(viewModel: MyProfileViewModel()).toolbarRole(.editor)) {
                Image("CaretRight")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.gray500Text)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    // 레벨 정보
    private var gradeSection: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text("\(viewModel.nextLevelGoals)골")
                        .pretendardTextStyle(.Title2Style)
                    Text("더 모으면 \(viewModel.nextBallLevel) 달성")
                        .pretendardTextStyle(.Body2Style)
                }
                HStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(minWidth: 300, maxHeight: 8)
                            .foregroundStyle(.grayCard)
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300 * viewModel.progressPercentage, height: 8)
                            .foregroundStyle(.lime)
                    }
                    .overlay {
                        HStack {
                            Text("\(viewModel.currentBallLevel.minGoal)골")
                            Spacer()
                            Text("\(viewModel.currentBallLevel.maxGoal)골  ")
                        }
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.white0)
                        .padding(.top, 36)
                    }
                    Image("ball\(viewModel.getIndexForBallLevel(viewModel.nextBallLevel)!)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }.padding(.top, -10)
            }.padding(.bottom, 8)
        }
    }
    
    
    // 내가 응원하는 팀
    private var myTeamSection: some View {
        VStack{
            HStack {
                Text("내가 응원하는 팀")
                    .foregroundStyle(.white0)
                    .pretendardTextStyle(.Title2Style)
                Spacer()
                NavigationLink(destination: EditMyTeams(viewModel: EditMyTeamsViewModel()).toolbarRole(.editor)) {
                    Text("수정")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.gray500Text)
                }
            }
            .padding(.bottom, 16)
            HStack(alignment: .bottom, spacing: 8){
                ForEach(Array(viewModel.favoriteTeamsUrl
                    .enumerated()), id: \.element.name) { index, team in
                        VStack(spacing: 0) {
                            LoadableImage(image: team.imageUrl)
                                .frame(width: 48, height: 48)
                                .padding(.bottom, 8)
                            Text(team.name)
                                .font(.pretendard(.medium, size: 13))
                                .padding(.bottom, 4)
                            SpecificRoundedRectangle(radius: 6, corners: [.topLeft, .topRight])
                                .frame(width: 100, height: 30-CGFloat(index * 5))
                                .foregroundStyle(.gray900Assets)
                                .overlay {
                                    if index == 0 {
                                        Text("\(index + 1)")
                                            .pretendardTextStyle(.Body3Style)
                                            .foregroundStyle(.white)
                                    } else if index == 1 {
                                        Text("\(index + 1)")
                                            .pretendardTextStyle(.Body3Style)
                                            .foregroundStyle(.gray300)
                                    } else {
                                        Text("\(index + 1)")
                                            .pretendardTextStyle(.Body3Style)
                                            .foregroundStyle(.gray600)
                                    }
                                    
                                }
                        }
                    }
            }//:HSTACK
            Divider().foregroundStyle(.gray900Assets)
                .padding(.top, -8)
        }.padding(.vertical, 16)
    }
    
    // 메뉴 종류
    private var menuList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("앱 활동")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.gray500)
                .padding(.top, 10)
            menuItem(title: "좋아요한 축구 일기", destination: AnyView(LikesDiary()))
            menuItem(title: "알림 설정", destination: AnyView(SetupAlerts()))
            themeItem
            menuItem(title: "서비스 이용 약관", destination: AnyView(TermsOfService()))
            menuItem(title: "개인정보 처리방침", destination: AnyView(PrivacyPolicy()))
            menuItem(title: "문의하기", destination: nil)
        }
    }
    
    // 메뉴 ui
    private func menuItem(title: String, destination: AnyView?) -> some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination.toolbarRole(.editor)) {
                    HStack {
                        Text(title)
                        Spacer()
                        Image("CaretRight")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundStyle(.gray800Btn)
                    }
                }.padding(.vertical, 15)
            } else {
                HStack {
                    Text(title)
                    Spacer()
                    Image("CaretRight")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundStyle(.gray800Btn)
                }.padding(.vertical, 15)
            }
        }
    }
    
    // 테마 설정
    private var themeItem: some View {
        HStack {
            Text("테마")
            Spacer()
            Text(viewModel.isDarkMode ? "다크 모드" : "라이트 모드")
                .foregroundStyle(.gray500Text)
                .pretendardTextStyle(.Body2Style)
        }
        .padding(.vertical, 15)
        .onTapGesture {
            viewModel.toggleDarkMode()
        }
    }
    
    // 로그아웃, 탈퇴하기
    private var accountActions: some View {
        HStack(spacing: 20) {
            Spacer()
            Button("로그아웃") {
                viewModel.showingLogoutAlert = true
            }.foregroundStyle(.gray500).pretendardTextStyle(.Body2Style)
                .frame(width: 57, height: 20)
            Divider().foregroundStyle(.gray800Btn)
                .frame(width: 1, height: 15, alignment: .center)
            NavigationLink(destination: DeleteAccount().toolbarRole(.editor)) {
                Text("탈퇴하기")
                    .foregroundStyle(.gray500).pretendardTextStyle(.Body2Style)
                    .frame(width: 57, height: 20)
            }
            Spacer()
        }
    }
}

#Preview {
    MyPage()
}
