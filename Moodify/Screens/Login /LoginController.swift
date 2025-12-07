//
//  LoginController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 27.11.25.
//

import UIKit
import Lottie

class LoginController: BaseViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in with Email"
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email adress"
        tf.textColor = .label
        tf.layer.cornerRadius = 12
        tf.autocapitalizationType = .none
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "buttonColor")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    let vm = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        let items = [topLabel, stackView, loginButton, signUpButton, animationView]
        items.forEach { view.addSubview($0) }
        passwordTextField.delegate = self
        setupConstraints()
    }
    
    override func setupConstraints() {
        let constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            signUpButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor,constant: -8),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func startLoadingAnimation() {
        animationView.isHidden = false
        animationView.animation = LottieAnimation.named("Loading")
        animationView.loopMode = .loop
        navigationItem.hidesBackButton = true
        view.isUserInteractionEnabled = false
        animationView.play()
    }
    
    func stopLoadingAnimation() {
        animationView.stop()
        navigationItem.hidesBackButton = false
        view.isUserInteractionEnabled = true
        animationView.isHidden = true
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Fail", message: "Email or password is empty")
            return }
        
        startLoadingAnimation()
        Task {
            do {
                defer {
                    stopLoadingAnimation()
                }
                
                try await vm.login(email: email, password: password)
                showAlert(title: "Success", message: "You are loged in") {
                    UIApplication.sceneDelegate?.changeRootToHome()
                    UserDefaultsManager.shared.saveDataBool(value: true, key: .isLogedIn)
                }
                
            } catch {
                showAlert(title: "Error", message: "\(error.localizedDescription) please try again")
            }
        }
        
        
    }
    
    @objc private func signUpTapped() {
        let cordinator = SignupCordinator(navigation: self.navigationController ?? UINavigationController())
        cordinator.start()
    }
    
    
}

extension LoginController: UITextFieldDelegate {
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
