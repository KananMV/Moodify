//
//  ViewController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.11.25.
//

import UIKit
import AVFoundation
import AWSRekognition



class HomeController: BaseViewController {
    
    private let vm = HomeViewModel(emotionAnalyzer: AWSAdapter())
    private let moods: [EmotionType] = [
        .happy, .sad, .angry, .confused, .disgusted, .surprised, .calm, .fear
    ]
    
    private lazy var collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MoodsCollectionViewCell.self, forCellWithReuseIdentifier: "MoodsCollectionViewCell")
        
        return collectionView
    }()
    
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
    
    private var selectedIndex: IndexPath?
    
    override func setupView() {
        navigationItem.backButtonTitle = "Back"
        view.backgroundColor = UIColor(named: "controllerBackColor")
        title = "Moodify"
        view.addSubview(topLabel)
        view.addSubview(moodButton)
        view.addSubview(collectionView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func setupConstraints() {
        let constraints = [
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            moodButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            moodButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moodButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            moodButton.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func buttonTapped() {
        if let index = selectedIndex {
            let selectedMood = moods[index.item]
            
            let cordinator = PlaylistTabsCoordinator(navigation: self.navigationController ?? UINavigationController(), mood: selectedMood.rawValue)
            cordinator.start()
            return
        }
        
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
            showActionAlert(title: "Camera Permission Disabled", message: "To continue, please allow camera access in Settings.", okTitle: "Open Settings", cancelTitle: "Cancel",onOk: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }, onCancel: {})
        case .authorized:
            presentImagePicker()
        default :
            break
        }
    }
}

extension HomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        let fixedImage = selectedImage.fixedFrontCameraOrientation()
        
        guard let data = fixedImage.jpegData(compressionQuality: 0.7) else { return }
        
        let cordinator = ScanCordinator(navigation: self.navigationController ?? UINavigationController(), pickedImage: data)
        
        picker.dismiss(animated: true) {
            cordinator.start()
        }
    }
    
    func updateButtonText(_ text: String) {
        UIView.transition(with: moodButton,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.moodButton.setTitle(text, for: .normal)
        }, completion: nil)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodsCollectionViewCell", for: indexPath) as? MoodsCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(emotion: moods[indexPath.row])
        
        if selectedIndex == indexPath {
            cell.setSelectedState(true)
        } else {
            cell.setSelectedState(false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath {
            selectedIndex = nil
            updateButtonText("Scan Mood")
        }else {
            selectedIndex = indexPath
            let selectedEmotion = moods[indexPath.item]
            updateButtonText("Search playlist for \(selectedEmotion.rawValue) mood")
        }
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let emotion = moods[indexPath.item]
        let text = emotion.rawValue
        
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let textWidth = (text as NSString).size(withAttributes: [.font: font]).width
        let width = textWidth + 12
        return CGSize(width: width, height: 50)
    }
}
