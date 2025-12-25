//
//  PodcastPlaylistController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.12.25.
//

import UIKit

class PodcastPlaylistController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PlaylistCollectionCell.self, forCellWithReuseIdentifier: "PlaylistCollectionCell")
        return view
    }()
    
    

    override func setupView() {
        view.backgroundColor = .controllerBack
        view.addSubview(collectionView)
         navigationController?.navigationBar.tintColor = .white
    }
    
    override func configureViewModel() {
        
        vm.success = { [weak self] in
            self?.collectionView.reloadData()
        }

        vm.error = { [weak self] error in
            self?.showAlert(title: "Error", message: error)
        }

        Task {
            await vm.getPodcasts()
        }
        
        
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    let vm: PodcastViewModel
    

    init(vm: PodcastViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PodcastPlaylistController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionCell", for: indexPath) as? PlaylistCollectionCell else { return UICollectionViewCell() }
        cell.configure(playlist: vm.items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let urlString = vm.items[indexPath.item].trackViewUrl ?? ""
            let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

            guard let url = URL(string: trimmed) else {
                showAlert(title: "Error", message: "Podcast link is not correct")
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
}
