//
//  ProfileController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.11.25.
//

import UIKit
import SafariServices

class ProfileController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(LeftImageCenterLabelCell.self, forCellReuseIdentifier: "LeftImageCenterLabelCell")
        tableView.register(ProfileImageNameLabelCell.self, forCellReuseIdentifier: "ProfileImageNameLabelCell")
        return tableView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "buttonColor")
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 48)
        return button
    }()
    
    private let options = [
        ProfileOptionsModel(icon: "person.fill", text: "Profile"),
        ProfileOptionsModel(icon: "book.fill", text: "Terms of service"),
        ProfileOptionsModel(icon: "checkmark.shield.fill", text: "Privacy")
    ]

    
    override func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        view.addSubview(tableView)
        title = "Profile"
        tableView.tableFooterView = logoutButton
    }
    
    override func setupConstraints() {
        
        let constraints =  [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
         
    }
    
    let vm: ProfileViewModel
    var imageData: Data?
    
    init(vm: ProfileViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleLogout() {
        Task { [weak self] in
            do {
                try await self?.vm.logout()
                UIApplication.sceneDelegate?.changeRootToEntryFromOnboard()
                UserDefaultsManager.shared.removeData(key: .email)
                UserDefaultsManager.shared.removeData(key: .isLogedIn)
                UserDefaultsManager.shared.removeData(key: .uid)
                
            } catch {
                self?.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewModel()
    }
    
    override func configureViewModel() {
        Task {
            do {
                try await vm.getProfileData()
                tableView.reloadData()
            } catch {
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    @objc private func logoutTapped() {
        showActionAlert(
            title: "Log out",
            message: "Are you sure you want to log out?",
            okTitle: "Cancel",
            cancelTitle: "Log out",
            onCancel:  { [weak self] in
            self?.handleLogout()
        })
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    enum Section: Int, CaseIterable {
        case profile
        case options
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .profile:
            return 1
        case .options:
            return options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageNameLabelCell", for: indexPath) as? ProfileImageNameLabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.imageDataCallback = { [weak self] data in
                guard let self else { return }
                self.imageData = data
            }
            cell.configure(data: vm.profile ?? Profile(fullName: nil, imageString: nil))
            return cell
        case .options:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeftImageCenterLabelCell", for: indexPath) as? LeftImageCenterLabelCell else { return UITableViewCell() }
            cell.configure(data: options[indexPath.row])
            cell.selectionStyle = .none
            return cell
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        let totalHeight = tableView.frame.height
        let profileHeight = totalHeight / 3
        
        switch section {
        case .profile:
            return profileHeight
        case .options:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .profile:
            return 0
        case .options:
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), section == .options else { return }
        
        let option = options[indexPath.row].text
        
        switch option {
        case "Profile":
            let vc = ProfileEditController(vm: .init(fullName: vm.profile?.fullName ?? "", userFireStoreService: FirestoreAdapter(), userFireStorageService: FireStorageAdapter(), profileImage: imageData!))
            navigationController?.show(vc, sender: self)
        case "Privacy":
            openURL("https://kananmv.github.io/App-Policy-Terms/privacy-policy.html")
            
        case "Terms of service":
            openURL("https://kananmv.github.io/App-Policy-Terms/terms-conditions.html")
            
        default:
            break
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
