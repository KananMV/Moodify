//
//  EmotionAnalyzer.swift
//  Moodify
//
//  Created by Kenan Memmedov on 05.12.25.
//

import Foundation
protocol EmotionAnalyzer {
    func analyze(imageData: Data, completion: @escaping (String) -> Void) 
}
