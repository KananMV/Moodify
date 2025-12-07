//
//  AWSAdapter.swift
//  Moodify
//
//  Created by Kenan Memmedov on 05.12.25.
//

import Foundation

class AWSAdapter: EmotionAnalyzer {
    func analyze(imageData: Data, completion: @escaping (String) -> Void) {
        AWSRekognitionManager.shared.detectTopEmotion(image: imageData) { emotion, confidence in
            
            let type: EmotionType = {
                switch emotion {
                case .happy: return .happy
                case .sad: return .sad
                case .angry: return .angry
                case .confused: return .confused
                case .disgusted: return .disgusted
                case .surprised: return .surprised
                case .calm: return .calm
                case .fear: return .fear
                case .unknown: return .unknown
                @unknown default:
                    return .unknown
                }
            }()
            
            let finalText = "\(type.rawValue) (\(String(format: "%.1f", confidence))%)"
            completion(finalText)
            
        }
    }
    
    
}
