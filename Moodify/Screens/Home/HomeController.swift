//
//  ViewController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.11.25.
//

import UIKit
import AVFoundation

class HomeController: UIViewController {
    
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


}

extension HomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            sendImageToServer(selectedImage)
        }
    }
}

extension HomeController {
    func sendImageToServer(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // Backend URL (local serverin IP və portu)
        let url = URL(string: "http://192.168.1.84:8000/analyze-mood")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Body yarat
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        // Sorğu göndər
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let data = data else { return }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Server response:", jsonString)
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let mood = json["mood"] as? String {
                    DispatchQueue.main.async {
                        self?.topLabel.text = "Mood: \(mood.capitalized)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.topLabel.text = "Mood: Unknown"
                    }
                }
            } catch {
                print("JSON parse error:", error)
            }
        }
        task.resume()
    }
}
