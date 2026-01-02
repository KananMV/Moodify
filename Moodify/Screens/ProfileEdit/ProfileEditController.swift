//
//  ProfileEditController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 30.12.25.
//

import UIKit
import AVFoundation

class ProfileEditController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: "EditProfileCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "buttonColor")
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 48)
        return button
    }()
    
    let vm: ProfileEditViewModel
    private var currentFullName: String
    
    init(vm: ProfileEditViewModel) {
        self.vm = vm
        self.currentFullName = vm.fullName
        super.init(nibName: nil, bundle: nil)
    }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupView() {
        view.backgroundColor = .controllerBack
        view.addSubview(tableView)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = saveButton
    }

    
    override func setupConstraints() {
        let keyboardGuide = view.keyboardLayoutGuide
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            tableView.bottomAnchor.constraint(equalTo: keyboardGuide.topAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    if granted {
                        self.openCamera()
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
            openCamera()
        default :
            break
        }
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func openLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func saveTapped() {
        Task {
            do {
                try await vm.updateFullName(currentFullName)
                let downloadImageUrl = try await vm.uploadImageData(vm.profileImage)
                try await vm.updateProfileImageURL(downloadImageUrl)
                showAlert(title: "Success", message: "Updated successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
}

extension ProfileEditController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell") as? EditProfileCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(name: vm.fullName, profileImageData: vm.profileImage)
        cell.onFullNameChanged = { [weak self] name in
            self?.currentFullName = name
        }
        cell.stackTappedHandler = { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(
                title: "How would you like to update your profile picture?",
                message: nil,
                preferredStyle: .actionSheet
            )
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.checkCameraPermission()
            })
            alert.addAction(UIAlertAction(title: "Library", style: .default) { _ in
                self.openLibrary()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            if let popover = alert.popoverPresentationController {
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                            y: self.view.bounds.midY,
                                            width: 0,
                                            height: 0)
                popover.permittedArrowDirections = []
            }

            self.present(alert, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    
}

extension ProfileEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        guard let data = selectedImage.jpegData(compressionQuality: 0.7) else { return }
        vm.profileImage = data
        tableView.reloadData()
    }
}
