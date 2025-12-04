//
//  EntryController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 27.11.25.
//

import UIKit

class EntryController: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Moodify"
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your personal soundtrack to every emotion. Sign in to start your journey."
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "buttonColor")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue with Email", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "secondButtonColor")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [googleButton, emailButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let privacyAndPolicyLabel: UILabel = {
        let label = UILabel()
        label.text = "By continuing, you agree to our Terms of Service and Privacy Policy."
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        title = "Moodify"
        view.backgroundColor = UIColor(named: "controllerBackColor")
        view.addSubview(topLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(stackView)
        view.addSubview(privacyAndPolicyLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        let constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            privacyAndPolicyLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            privacyAndPolicyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            privacyAndPolicyLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func emailButtonTapped() {
        let vc = LoginController()
        navigationController?.show(vc, sender: nil)
    }
    
}
