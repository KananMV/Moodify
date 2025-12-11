//
//  ScanController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 06.12.25.
//

import UIKit
import Lottie

class ScanController: BaseViewController {
    
    private var animationView: LottieAnimationView?
    
    private var pickedImage: UIImage?
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Scanning emotion..."
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
    
    private let vm: ScanViewModel
    
    init(vm: ScanViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        self.pickedImage = UIImage(data: vm.pickedImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .controllerBack
        view.addSubview(topLabel)
        view.addSubview(image)
        image.image = pickedImage
    }
    
    private func showScanAnimation() {
        animationView = .init(name: "RedScanEffect")
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .loop
        
        guard let animationView else { return }
        image.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: image.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        
        animationView.play()
    }
    
    override func configureViewModel() {
        
        showScanAnimation()
        
        vm.onEmotionUpdated = { [weak self] emotion in
            guard let self = self else { return }
            
            let cordinator = ScanResultCordinator(navigation: self.navigationController ?? UINavigationController(), pickedImage: self.vm.pickedImage, emotion: emotion)
            animationView?.stop()
            animationView?.isHidden = true
            cordinator.start()
        }
        vm.analyze()
    }
    
    override func setupConstraints() {
        guard let pickedImage = pickedImage else { return }
        let ratio = pickedImage.size.height / pickedImage.size.width
        let constraints = [
            
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            image.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: ratio)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
