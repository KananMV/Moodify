//
//  ScanCordinator.swift
//  Moodify
//
//  Created by Kenan Memmedov on 06.12.25.
//

import UIKit

class ScanCordinator: Cordinator {
    var navigation: UINavigationController
    var pickedImage: Data
    
    init(navigation: UINavigationController, pickedImage: Data) {
        self.navigation = navigation
        self.pickedImage = pickedImage
    }
    
    
    func start() {
        navigation.navigationBar.isHidden = true
        let vc = ScanController(vm: .init(pickedImage: pickedImage, emotionAnalyzer: AWSAdapter()))
        navigation.show(vc, sender: nil)
    }
    
    
}
