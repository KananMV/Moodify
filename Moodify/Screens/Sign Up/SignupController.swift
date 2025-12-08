//
//  SignupController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 01.12.25.
//

import UIKit
import Lottie

class SignupController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(SignupTableViewCell.self, forCellReuseIdentifier: "SignupTableViewCell")
        return tableView
    }()
    
    private let vm = SignupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        view.addSubview(tableView)
        setupConstraints()
    }
    
    override func setupConstraints() {
        let keyboardGuide = view.keyboardLayoutGuide
         let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            tableView.bottomAnchor.constraint(equalTo: keyboardGuide.topAnchor, constant: -8)
         ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension SignupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SignupTableViewCell") as? SignupTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.onCreateAccountTapped = { [weak self] fullName, email, password in
            guard let self = self else { return }
            cell.startLoadingAnimation()
            navigationItem.hidesBackButton = true
            view.isUserInteractionEnabled = false
            Task {
                do {
                    defer {
                        cell.stopLoadingAnimation()
                        self.navigationItem.hidesBackButton = false
                        self.view.isUserInteractionEnabled = true
                    }
                    
                    try await self.vm.signUp(email: email, password: password, fullName: fullName)
                    self.showAlert(title: "Success", message: "You have successfully signed up!")
                } catch {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        return cell
    }
    
    
}
