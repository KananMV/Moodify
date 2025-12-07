//
//  EmotionType.swift
//  Moodify
//
//  Created by Kenan Memmedov on 05.12.25.
//

import Foundation

enum EmotionType: String {
    case happy = "Happy 😄"
    case sad = "Sad 😢"
    case angry = "Angry 😡"
    case confused = "Confused 🤔"
    case disgusted = "Disgusted 🤢"
    case surprised = "Surprised 😲"
    case calm = "Calm 😌"
    case fear = "Fear 😨"
    case unknown = "Unknown 😐"
    
    var titleOnly: String {
        rawValue.components(separatedBy: " ").first ?? rawValue
    }
}
