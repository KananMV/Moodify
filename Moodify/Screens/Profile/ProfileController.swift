//
//  ProfileController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.11.25.
//

import UIKit

class ProfileController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupConstraints() {
        
    }
    
    override func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
    }
}
