//
//  KeyboardController.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation
import UIKit
import SwiftUI

/// 축구 일기 작성 시, 키보드 위에 뷰를 띄우기 위한 TextEditor 파일
struct KeyboardTextEditor<AccessoryView: View>: UIViewRepresentable {
    @Binding var text: String
    @Binding var textCount: Int
    let accessoryView: () -> AccessoryView

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 16)
        
        // 기존 여백 제거
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        // 배경색 제거
        textView.backgroundColor = .clear
        textView.isOpaque = false
        
        let hostingController = UIHostingController(rootView: accessoryView())
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        textView.inputAccessoryView = hostingController.view
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: KeyboardTextEditor

        init(_ parent: KeyboardTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            // 500자 제한
            if textView.text.count > 500 {
                textView.text = String(textView.text.prefix(500))
            }
            parent.text = textView.text
            parent.textCount = textView.text.count
        }
    }
}
