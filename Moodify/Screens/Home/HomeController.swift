//
//  ViewController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.11.25.
//

import UIKit
import AVFoundation
import AWSRekognition



class HomeController: UIViewController {
    
    private let vm = HomeViewModel()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling today?"
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moodButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan Mood", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "buttonColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        title = "Moodify"
        view.addSubview(topLabel)
        view.addSubview(moodButton)
        
        setupCons()
    }
    
    private func setupCons() {
        let constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            moodButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            moodButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moodButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moodButton.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func buttonTapped() {
        checkCameraPermission()
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    if granted {
                        self.presentImagePicker()
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
        case .restricted, .denied:
            let alert = UIAlertController(
                title: "Camera Permission Disabled",
                message: "To continue, please allow camera access in Settings.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            
            self.present(alert, animated: true)
            
        case .authorized:
            presentImagePicker()
        default :
            break
        }
    }
    
    func configureViewModel() {
        vm.onEmotionUpdated = { [weak self] emotion in
            guard let self else { return }
            self.topLabel.text = emotion
        }
    }
    
    
    
}

extension HomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[.originalImage] as? UIImage {
            
            guard let data = selectedImage.jpegData(compressionQuality: 0.7) else { return }
            vm.analyze(image: data)
        }
    }
}
