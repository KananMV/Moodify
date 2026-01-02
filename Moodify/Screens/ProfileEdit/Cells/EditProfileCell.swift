//
//  EditPictureCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 30.12.25.
//

import UIKit


class EditProfileCell: UITableViewCell {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tabbar
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(profileImage)
        view.clipsToBounds = false
        return view
    }()
    
    private let editLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Edit Picture"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContainer, editLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Full Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.backgroundColor = .tabbar
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.placeholder = "Enter your full name"
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(fullNameDidChange), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.placeholder = UserDefaultsManager.shared.getDataString(key: .email)
        textField.isUserInteractionEnabled = false
        textField.layer.masksToBounds = true
        textField.backgroundColor = .tabbar
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    var stackTappedHandler: (() -> Void)?
    var onFullNameChanged: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layoutIfNeeded()
        imageContainer.layer.cornerRadius = imageContainer.frame.width / 2
        imageContainer.clipsToBounds = true
    }
    
    func setupView() {
        backgroundColor = .clear
        
        let items = [stackView, fullNameLabel, fullNameTextField, emailLabel, emailTextField]
        items.forEach { contentView.addSubview($0) }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.44),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            profileImage.topAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.trailingAnchor),
            profileImage.bottomAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.bottomAnchor),
            
            fullNameLabel.leadingAnchor.constraint(equalTo: fullNameTextField.leadingAnchor, constant: 8),
            fullNameLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            
            
            fullNameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor,constant: 8),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 8),
            emailLabel.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 16),
            
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            emailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func fullNameDidChange() {
        onFullNameChanged?(fullNameTextField.text ?? "")
    }
    
    @objc private func stackTapped() {
        stackTappedHandler?()
    }
    
    func configure(name: String, profileImageData: Data? = nil) {
        fullNameTextField.text = name
        
        if let data = profileImageData {
            print(data)
            profileImage.image = UIImage(data: data)
        }
        
        
    }
}
