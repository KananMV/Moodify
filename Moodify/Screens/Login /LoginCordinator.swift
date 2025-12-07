//
//  LoginCordinator.swift
//  Moodify
//
//  Created by Kenan Memmedov on 04.12.25.
//

import UIKit

class LoginCordinator: Cordinator {
    var navigation: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigation = navigationController
    }
    
    func start() {
        let vc = LoginController()
        navigation.show(vc, sender: nil)
    }
}
