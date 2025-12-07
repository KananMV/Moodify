//
//  ScanResultCordinator.swift
//  Moodify
//
//  Created by Kenan Memmedov on 05.12.25.
//

import UIKit

class ScanResultCordinator: Cordinator {
    var navigation: UINavigationController
    var pickedImage: Data
    var emotion: String
    
    init(navigation: UINavigationController, pickedImage: Data, emotion: String) {
        self.navigation = navigation
        self.pickedImage = pickedImage
        self.emotion = emotion
    }
    
    func start() {
        let vc = ScanResultController(viewModel: .init(pickedImage: pickedImage, emotion: emotion))
        navigation.show(vc, sender: nil)
    }
    
}
