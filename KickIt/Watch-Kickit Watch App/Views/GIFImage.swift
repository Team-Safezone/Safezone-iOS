//
//  GIFImage.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 10/29/24.
//

import SwiftUI
import ImageIO

struct GIFImageView: View {
    let images: [Image]
    let frameDuration: Double
    @State private var currentFrame = 0

    init(gifName: String) {
        self.images = GIFImageView.loadGIFFrames(gifName: gifName)
        self.frameDuration = 0.05
    }
    
    var body: some View {
        images[currentFrame]
            .resizable()
            .scaledToFit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { timer in
                    currentFrame = (currentFrame + 1) % images.count
                }
            }
    }

    static func loadGIFFrames(gifName: String) -> [Image] {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return []
        }
        
        var frames: [Image] = []
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                frames.append(Image(uiImage: uiImage))
            }
        }
        
        return frames
    }
}
