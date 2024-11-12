//
//  MyPageViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 10/11/24.
//

import Combine
import Foundation

// 마이페이지 뷰모델
class MyPageViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var goalCount: Int = 0
    @Published var favoriteTeamsUrl: [(teamName: String, teamUrl: String)] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // 볼 레벨 정의
    private let ballLevels: [(name: String, minGoal: Int, maxGoal: Int)] = [
        ("탱탱볼", 0, 20),
        ("브론즈 공", 21, 50),
        ("실버 공", 51, 90),
        ("골드 공", 91, 140),
        ("다이아 공", 141, 200)
    ]
    
    init() {
        fetchUserData()
    }
    
    // 사용자 데이터 GET API 호출
    func fetchUserData() {
            MyPageAPI.shared.getUserInfo()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching user data: \(error)")
                    }
                } receiveValue: { [weak self] userData in
                    self?.nickname = userData.nickname
                    // 앱 내에서 이메일 가져오기
                    self?.email = KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "email@nodata"
                    self?.goalCount = userData.goalCount
                    self?.favoriteTeamsUrl = userData.favoriteTeamsUrl.map { ($0.teamName, $0.teamUrl) }
                }
                .store(in: &cancellables)

        // 임시 데이터
        self.nickname = "닉네임"
        self.email = "email@naver.com"
        self.goalCount = 1
        self.favoriteTeamsUrl = [("토트넘", "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png"),
                                 ("리버풀","https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F44_300300.png"),
                                 ("맨시티","https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png")]
    }
    
    // 현재 볼 레벨
    var currentBallLevel: (name: String, minGoal: Int, maxGoal: Int) {
        ballLevels.first { goalCount >= $0.minGoal && goalCount <= $0.maxGoal } ?? ballLevels.last!
    }
    
    // 다음 볼 레벨
    var nextBallLevel: String {
        let currentIndex = ballLevels.firstIndex { $0.maxGoal >= goalCount } ?? (ballLevels.count - 1)
        return currentIndex < ballLevels.count - 1 ? ballLevels[currentIndex + 1].name : "최고 레벨"
    }
    
    // 다음 레벨까지 남은 골 수
    var nextLevelGoals: Int {
        max(currentBallLevel.maxGoal - goalCount, 0)
    }
    
    // 볼 이름 -> index(image용)
    func getIndexForBallLevel(_ levelName: String) -> Int? {
        return ballLevels.firstIndex { $0.name == levelName }
    }
    
    // 현재 레벨 내 진행률
    var progressPercentage: CGFloat {
        let range = currentBallLevel.maxGoal - currentBallLevel.minGoal
        let progress = goalCount - currentBallLevel.minGoal
        return CGFloat(progress) / CGFloat(range)
    }
}
