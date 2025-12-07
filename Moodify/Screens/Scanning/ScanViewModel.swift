//
//  ScanViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 06.12.25.
//

import Foundation

class ScanViewModel {
    let pickedImage: Data
    
    var onEmotionUpdated: ((String) -> Void)?
    
    private let emotionAnalyzer: EmotionAnalyzer
    
    init(pickedImage: Data, emotionAnalyzer: EmotionAnalyzer) {
        self.pickedImage = pickedImage
        self.emotionAnalyzer = emotionAnalyzer
    }
    
    func analyze() {
        emotionAnalyzer.analyze(imageData: pickedImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.onEmotionUpdated?(result)
            }
            
        }
    }
    
}
