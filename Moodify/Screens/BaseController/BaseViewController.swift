//
//  BaseViewController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 04.12.25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        configureViewModel()
    }
    
    func setupView() {}
    
    func setupConstraints() {}

    func configureViewModel() {}
}
