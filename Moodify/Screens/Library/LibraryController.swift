//
//  LibraryController.swift
//  Moodify
//

import UIKit

class LibraryController: BaseViewController {
    
    private let viewModel = LibraryViewModel(userFavoritesService: FirestoreAdapter())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.delegate = self
        view.dataSource = self
        view.register(LibraryCell.self, forCellWithReuseIdentifier: "PlaylistCell")
        return view
    }()
    
    private lazy var dropdownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Music ▾", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven’t added any playlists yet.Find and add music or podcasts from the Home screen."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        view.backgroundColor = UIColor(named: "controllerBackColor")
        view.addSubview(dropdownButton)
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        setupDropdown()
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
            
            
        ])
    }
    
    private func setupDropdown() {
        dropdownButton.addTarget(self, action: #selector(dropdownTapped), for: .touchUpInside)
        dropdownButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        dropdownButton.setTitleColor(.label, for: .normal)
        dropdownButton.contentHorizontalAlignment = .left
    }
    
    private func updateEmptyState() {
        let isEmpty: Bool
        
        switch viewModel.currentCollection {
        case .musics:
            isEmpty = viewModel.musicFavorites.isEmpty
        case .podcasts:
            isEmpty = viewModel.podcastFavorites.isEmpty
        }
        
        emptyLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    
    
    @objc private func dropdownTapped() {
        let alert = UIAlertController(title: "Select Favorites", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Music", style: .default, handler: { [weak self] _ in
            self?.dropdownButton.setTitle("Music ▾", for: .normal)
            self?.viewModel.changeCollection(to: .musics) {
                self?.collectionView.reloadData()
                self?.updateEmptyState()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Podcast", style: .default, handler: { [weak self] _ in
            self?.dropdownButton.setTitle("Podcast ▾", for: .normal)
            self?.viewModel.changeCollection(to: .podcasts) {
                self?.collectionView.reloadData()
                self?.updateEmptyState()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func fetchData() {
        viewModel.fetchFavorites {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavorites { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }, completion: nil)
                self?.updateEmptyState()
            }
        }
    }
}

extension LibraryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.currentCollection {
        case .musics:
            return viewModel.musicFavorites.count
        case .podcasts:
            return viewModel.podcastFavorites.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCell", for: indexPath) as? LibraryCell else {
            return UICollectionViewCell()
        }
        
        switch viewModel.currentCollection {
        case .musics:
            let playlist = viewModel.musicFavorites[indexPath.item]
            cell.configure(coverURL: playlist.playlistCoverImage ?? "",title: playlist.playlistName ?? "")
        case .podcasts:
            let playlist = viewModel.podcastFavorites[indexPath.item]
            cell.configure(coverURL: playlist.playlistCoverImage ?? "",title: playlist.playlistName ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.currentCollection {
        case .musics:
            let playlist = viewModel.musicFavorites[indexPath.item]
            let vc = MusicPlaylistController(vm: .init(playlist: playlist, musicURLManager: MusicManager(), musicFavoritesService: FirestoreAdapter()))
            navigationController?.pushViewController(vc, animated: true)
        case .podcasts:
            let playlist = viewModel.podcastFavorites[indexPath.item]
            let vc = PodcastPlaylistController(vm: .init(playlist: playlist, podcastFavoritesService: FirestoreAdapter()))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 48) / 2
        let height = width + 25
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
