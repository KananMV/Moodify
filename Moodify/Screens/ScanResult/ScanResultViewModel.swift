//
//  ScanResultViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 06.12.25.
//

import Foundation

class ScanResultViewModel {
    let pickedImage: Data
    let emotion: String
    
    init(pickedImage: Data, emotion: String) {
        self.pickedImage = pickedImage
        self.emotion = emotion
    }
    
}
