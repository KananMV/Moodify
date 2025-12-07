//
//  SignupCordinator.swift
//  Moodify
//
//  Created by Kenan Memmedov on 04.12.25.
//

import UIKit

class SignupCordinator: Cordinator {
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let vc = SignupController()
        navigation.show(vc, sender: nil)
    }
}
