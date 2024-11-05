//
//  SnapshotView.swift
//  KickIt
//
//  Created by 이윤지 on 11/4/24.
//

import SwiftUI

// 축구 일기 공유 시, 원하는 크기로 뷰를 캡처
// SoccerDiary.swift에 있는 captureSnapshot함수의 이전 코드.
// 혹시 모르니 일단 남겨두는 파일
struct SnapshotView<Content: View>: UIViewRepresentable {
    let content: Content
    let onCapture: (UIImage?) -> Void
    let captureSize: CGSize // 캡처할 사이즈 전달
    
    init(content: Content, captureSize: CGSize, onCapture: @escaping (UIImage?) -> Void) {
        self.content = content
        self.captureSize = captureSize
        self.onCapture = onCapture
    }
    
    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = CGRect(origin: .zero, size: captureSize) // 지정된 크기 적용
        return hostingController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            let image = captureImage(from: uiView)
            onCapture(image)
        }
    }
    
    private func captureImage(from view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
