import Foundation

final class HomeViewModel {

    var onEmotionUpdated: ((String) -> Void)?
    
    private let emotionAnalyzer: EmotionAnalyzer
    
    
    init(emotionAnalyzer: EmotionAnalyzer) {
        self.emotionAnalyzer = emotionAnalyzer
    }
    
    func analyze(image: Data) {
        emotionAnalyzer.analyze(imageData: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.onEmotionUpdated?(result)
            }
            
        }
    }
    
}
