//
//  PhotoPicker.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation
import SwiftUI
import PhotosUI

// 갤러리에서 사진을 고를 수 있음
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedPhotos: [DiaryPhotoItem] // 선택된 이미지를 저장하는 리스트
    let maxImageLimit: Int = 5 // 최대 이미지 선택 가능 개수
    
    // 취소 버튼을 누른 경우
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // 사진 설정
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택하도록 설정
        configuration.selectionLimit = maxImageLimit - selectedPhotos.count // 최대 5장 선택 가능
        configuration.preferredAssetRepresentationMode = .current // 선택했던 이미지 기억
        
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    // 이미지 통신 코디네이터
    func makeCoordinator() -> Coordinator {
         return Coordinator(self)
    }
    
    // picker 업데이트
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // update x
    }
}

/// 코디네이터 클래스
class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: PhotoPicker
    
    // 사진이 하나 혹은 여러 개가 선택됐을 때 또는 사진 선택이 취소됐을 때 호출
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // 현재 picker 사라지게 만들기
        picker.dismiss(animated: true)
        
        guard results.count > 0 else { return }
        
        // 선택된 이미지 개수 확인
        let remainingCount = parent.maxImageLimit - parent.selectedPhotos.count
        if remainingCount <= 0 {
            print("이미지 더 이상 추가 불가능")
            return
        }
        
        // 선택한 이미지 추가
        for (index, result) in results.enumerated() {
            if index >= remainingCount { break } // 최대 이미지 개수 초과 시 선택 중단
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { img, error in
                    if let error = error {
                        print("Error 갤러리 이미지 로드: \(error.localizedDescription)")
                    } else if let img = img as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedPhotos.append(DiaryPhotoItem(photo: img))
                        }
                    }
                }
            }
        }
    }
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
}
