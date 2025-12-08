//
//  SignupTableViewCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 08.12.25.
//

import UIKit
import Lottie

class SignupTableViewCell: UITableViewCell {
    
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.textColor = .label
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.textColor = .label
        tf.layer.cornerRadius = 12
        tf.delegate = self
        tf.backgroundColor = UIColor(named: "secondButtonColor")
        tf.heightAnchor.constraint(equalToConstant: 56).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 16)
        tf.clearButtonMode = .whileEditing
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email adress"
        tf.textColor = .label
        tf.delegate = self
        tf.layer.cornerRadius = 12
        tf.backgroundColor = UIColor(named: "secondButtonColor")
        tf.heightAnchor.constraint(equalToConstant: 56).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 16)
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .label
        tf.delegate = self
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 12
        tf.backgroundColor = UIColor(named: "secondButtonColor")
        tf.heightAnchor.constraint(equalToConstant: 56).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 16)
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        
        tf.rightView = passwordRightContainer
        tf.rightViewMode = .whileEditing
        
        return tf
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "buttonColor")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
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
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    var onCreateAccountTapped: ((_ fullname: String, _ email: String, _ password: String) -> Void)?
    
    
    private lazy var passwordToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.tintColor = .gray
        btn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        btn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return btn
    }()
    
    private lazy var passwordRightContainer: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        v.addSubview(passwordToggleButton)
        passwordToggleButton.center = v.center
        return v
    }()
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func createButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let fullName = fullNameTextField.text, !fullName.isEmpty else { return }
        onCreateAccountTapped?(fullName,email,password)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        let items = [topLabel, fullNameTextField, emailTextField, passwordTextField, createButton, privacyAndPolicyLabel, animationView]
        items.forEach { contentView.addSubview($0) }
        
        setupConstraints()
    }
    
    private var animationBottomConstraint: NSLayoutConstraint!

    private func setupConstraints() {

        let constraints = [
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            fullNameTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            privacyAndPolicyLabel.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 8),
            privacyAndPolicyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            privacyAndPolicyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            animationView.topAnchor.constraint(equalTo: privacyAndPolicyLabel.bottomAnchor, constant: 8),
            animationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150),
            animationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func startLoadingAnimation() {
        animationView.isHidden = false
        animationView.animation = LottieAnimation.named("Loading")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func stopLoadingAnimation() {
        animationView.stop()
        animationView.isHidden = true
    }
    
    
}
extension SignupTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField == passwordTextField else { return true }
        let isDeleting = string.isEmpty && range.length == 1
        if passwordTextField.isSecureTextEntry && isDeleting {
            passwordTextField.text = ""
            return false
        }
        return true
    }
}

