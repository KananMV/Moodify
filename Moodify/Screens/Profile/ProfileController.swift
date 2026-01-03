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
    func numberOfSections(in tableView: UITableView) -> Int {
        vm.sections.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = vm.sections[indexPath.section]
        
        switch section.sectionType {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageNameLabelCell", for: indexPath) as? ProfileImageNameLabelCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(data: section.items[indexPath.row])
            
            return cell
        case .options:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeftImageCenterLabelCell", for: indexPath) as? LeftImageCenterLabelCell else { return UITableViewCell() }
            cell.configure(data: section.items[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalHeight = tableView.frame.height
        let profileHeight = totalHeight / 3
        
        switch vm.sections[indexPath.section].sectionType {
        case .profile:
            return profileHeight
        case .options:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        vm.sections[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemType = vm.sections[indexPath.section].items[indexPath.row].type
        
        switch itemType {
        case .profile:
            let vc = ProfileEditController(vm: .init(fullName: vm.profile?.fullName ?? "",
                                                     userFireStoreService: FirestoreAdapter(),
                                                     userFireStorageService: FireStorageAdapter(),
                                                     profileImage: vm.profile?.imageString ?? ""))
            navigationController?.show(vc, sender: self)
        case .privacyPolicy:
            openURL("https://kananmv.github.io/App-Policy-Terms/privacy-policy.html")
            
        case .termsOfService:
            openURL("https://kananmv.github.io/App-Policy-Terms/terms-conditions.html")
            
        case .none:
            break
        }
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
