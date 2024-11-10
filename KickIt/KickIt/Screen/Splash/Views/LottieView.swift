//
//  LottieView.swift
//  KickIt
//
//  Created by DaeunLee on 11/10/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        loadLottieFile(animationView: animationView)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = uiView.subviews.first as? LottieAnimationView else { return }
        loadLottieFile(animationView: animationView)
    }
    
    private func loadLottieFile(animationView: LottieAnimationView) {
        Task {
            do {
                // Try to load the .lottie file and catch errors if loading fails
                if let dotLottieFile = try? await DotLottieFile.named(name) {
                    await MainActor.run {
                        animationView.loadAnimation(from: dotLottieFile)
                        animationView.play()
                    }
                } else {
                    print("Failed to load .lottie file")
                }
            } catch {
                print("Error loading .lottie file: \(error)")
            }
        }
    }
}
