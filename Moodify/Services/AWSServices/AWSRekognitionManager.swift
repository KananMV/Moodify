import AWSRekognition

final class AWSRekognitionManager {
    
    static let shared = AWSRekognitionManager()
    private let rekognition = AWSRekognition.default()
    
    private init() {}
    
    func detectTopEmotion(
        image: Data,
        completion: @escaping (_ emotion: AWSRekognitionEmotionName, _ confidence: Double) -> Void) {
            
            let awsImage = AWSRekognitionImage()
            awsImage?.bytes = image
            
            let request = AWSRekognitionDetectFacesRequest()
            request?.image = awsImage
            request?.attributes = ["ALL"]
            
            rekognition.detectFaces(request!) { response, error in
                
                if let error = error {
                    print("AWS Error:", error.localizedDescription)
                    completion(.unknown, 0)
                    return
                }
                
                guard let faceDetails = response?.faceDetails?.first,
                      let emotions = faceDetails.emotions,
                      let topEmotion = emotions.max(by: {
                          ($0.confidence?.doubleValue ?? 0) < ($1.confidence?.doubleValue ?? 0)
                      })
                else {
                    completion(.unknown, 0)
                    return
                }
                
                let emotionEnum = topEmotion.types
                let confidence = topEmotion.confidence?.doubleValue ?? 0
                
                completion(emotionEnum, confidence)
            }
        }
}
