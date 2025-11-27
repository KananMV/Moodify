import Foundation
import UIKit
import AWSRekognition

final class HomeViewModel {

    var onEmotionUpdated: ((String) -> Void)?

    func analyze(image: UIImage) {
        AWSRekognitionManager.shared.detectTopEmotion(image: image) { emotion, confidence in

            let text: String
            switch emotion {
            case .happy:
                text = "Happy 😄"
            case .sad:
                text = "Sad 😢"
            case .angry:
                text = "Angry 😡"
            case .confused:
                text = "Confused 🤔"
            case .disgusted:
                text = "Disgusted 🤢"
            case .surprised:
                text = "Surprised 😲"
            case .calm:
                text = "Calm 😌"
            case .fear:
                text = "Fear 😨"
            case .unknown:
                text = "Unknown 😐"
            @unknown default:
                text = "Other 🤷‍♂️"
            }

            let finalText = "\(text) (\(String(format: "%.1f", confidence))%)"

            DispatchQueue.main.async {
                self.onEmotionUpdated?(finalText)
            }
        }
    }
}
