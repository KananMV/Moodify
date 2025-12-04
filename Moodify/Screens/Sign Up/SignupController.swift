//
//  SignupController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 01.12.25.
//

import UIKit

class SignupController: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.textColor = .label
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
        tf.layer.cornerRadius = 12
        tf.backgroundColor = UIColor(named: "secondButtonColor")
        tf.heightAnchor.constraint(equalToConstant: 56).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 16)
        tf.clearButtonMode = .whileEditing
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .label
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        let items = [topLabel, fullNameTextField ,emailTextField, passwordTextField, createButton, privacyAndPolicyLabel]
        items.forEach { view.addSubview($0) }
        passwordTextField.delegate = self
        setupConstraints()
    }
    
    private func setupConstraints() {
         let constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            fullNameTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            fullNameTextField.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            fullNameTextField.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: fullNameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: fullNameTextField.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            privacyAndPolicyLabel.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 12),
            privacyAndPolicyLabel.leadingAnchor.constraint(equalTo: createButton.leadingAnchor),
            privacyAndPolicyLabel.trailingAnchor.constraint(equalTo: createButton.trailingAnchor)
         ]
        
        NSLayoutConstraint.activate(constraints)
    }

}

extension SignupController: UITextFieldDelegate {
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
