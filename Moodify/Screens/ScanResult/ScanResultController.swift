//
//  ScanResultController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 05.12.25.
//

import UIKit

class ScanResultController: BaseViewController, UIGestureRecognizerDelegate {
    
    private var pickedImage: UIImage?
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan Complete!"
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    private let mood: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let moodDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var findPlaylist: UIButton = {
        let button = UIButton()
        button.setTitle("Find your playlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "buttonColor")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(findTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: ScanResultViewModel
    
    init(viewModel: ScanResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.pickedImage = UIImage(data: viewModel.pickedImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func setupView() {
        navigationItem.backButtonTitle = "Back"
        view.backgroundColor = .controllerBack
        title = "Mood scan"
        view.addSubview(topLabel)
        view.addSubview(image)
        view.addSubview(mood)
        view.addSubview(moodDescription)
        view.addSubview(findPlaylist)
        image.image = pickedImage
        mood.text = viewModel.emotion
        
        let emotion = viewModel.emotion.split(separator: " ").first.map(String.init) ?? viewModel.emotion

        moodDescription.text = "Your mood has been detected as \(emotion). Enjoy a curated playlist to match your vibe."
    }
    
    override func setupConstraints() {
        guard let pickedImage = pickedImage else { return }
        let ratio = pickedImage.size.height / pickedImage.size.width
        NSLayoutConstraint.activate([
            
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            image.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: ratio),
            
            mood.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            mood.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            mood.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            moodDescription.topAnchor.constraint(equalTo: mood.bottomAnchor, constant: 4),
            moodDescription.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            moodDescription.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            
            findPlaylist.topAnchor.constraint(equalTo: moodDescription.bottomAnchor, constant: 32),
            findPlaylist.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            findPlaylist.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor)
        ])
    }
    
    @objc func findTapped() {
        let cordinator = PlaylistTabsCoordinator(navigation: self.navigationController ?? UINavigationController(), mood: viewModel.emotion)
        cordinator.start()
    }

}
