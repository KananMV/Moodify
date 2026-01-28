import UIKit
import Lottie
import SafariServices

protocol CancellableController: AnyObject {
    func cancelFetching()
    func startFetchingPlaylist()
}

final class MusicPlaylistController: BaseViewController, CancellableController {
    func cancelFetching() {
        currentTask?.cancel()
        currentTask = nil
        hideLoader()
    }
    
    func startFetchingPlaylist() {
        if !vm.items.isEmpty { return }
        currentTask?.cancel()
        currentTask = Task { @MainActor in
            showLoader()
            defer { hideLoader() }
            await vm.getPlaylist()
        }
    }
    

    private var animationView: LottieAnimationView?
    private var currentTask: Task<Void, Never>?

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
        view.register(PlaylistCoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaylistCoverHeader")
        return view
    }()

    let vm: MusicPlaylistViewModel
    

    init(vm: MusicPlaylistViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        Task { @MainActor in
            showLoader()
            defer { hideLoader() }
            startFetchingPlaylist()
        }
    }

    private func showSavePlaylistAlert() {
        let alert = UIAlertController(
            title: "Playlist Name",
            message: "Give a name to your playlist",
            preferredStyle: .alert
        )

        alert.addTextField { tf in
            tf.placeholder = "New Playlist"
            tf.text = self.vm.playlistName
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self.vm.playlistName = text
            if let playlist = self.vm.currentPlaylist {
                let playlistWithName = CoreModel(
                    playlistId: playlist.playlistId,
                    playlistCoverImage: playlist.playlistCoverImage,
                    playlist: playlist.playlist,
                    playlistMood: self.vm.moodText,
                    playlistName: text
                )
                self.vm.currentPlaylist = playlistWithName
                Task {
                    do {
                        try await self.vm.musicFavoritesService.addToFavorites(
                            playlist: playlistWithName,
                            collection: .musics
                        )
                        self.vm.isFavorite = true
                        self.vm.success?()
                    } catch {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        })

        present(alert, animated: true)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showLoader() {
        let width = view.frame.width * 0.5
        let height = width
        let x = (view.frame.width - width) / 2
        let y = (view.frame.height - height - 150) / 2
        
        let animationView = LottieAnimationView(name: "Sparkles Loop Loader ai")
        animationView.frame = CGRect(x: x, y: y, width: width, height: height)
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.isUserInteractionEnabled = false

        view.addSubview(animationView)
        self.animationView = animationView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Task { @MainActor in
            self.hideLoader()
        }
    }
    
    private func hideLoader() {
        animationView?.stop()
        animationView?.removeFromSuperview()
        view.isUserInteractionEnabled = true
        animationView = nil
    }
}

extension MusicPlaylistController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PlaylistCollectionCell",
            for: indexPath
        ) as? PlaylistCollectionCell else {
            return UICollectionViewCell()
        }

        cell.configure(playlist: vm.items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMusicURL = vm.items[indexPath.item].youtubeSearchUrl ?? ""

        Task { @MainActor in
            showLoader()
            defer { hideLoader() }

            guard let urlString = await vm.getMusicURL(musicURL: selectedMusicURL),
                  let url = URL(string: urlString) else { return }

            let safari = SFSafariViewController(url: url)
            safari.modalPresentationStyle = .pageSheet
            safari.preferredControlTintColor = .white
            present(safari, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "PlaylistCoverHeader",
                for: indexPath
            ) as! PlaylistCoverHeader
            
            if let cover = vm.playlistCoverImageURL {
                header.configure(with: cover,mood: vm.moodText,titleLabelText: vm.currentPlaylist?.playlistName)
            }
            header.setSaved(vm.isFavorite)
            
            header.buttonTapped = { [weak self] in
                guard let self = self else { return }
                if !self.vm.isFavorite {
                    self.showSavePlaylistAlert()
                } else {
                    Task {
                        guard let playlist = self.vm.currentPlaylist else { return }
                        do {
                            try await self.vm.musicFavoritesService.removeFromFavorites(
                                playlist: playlist,
                                collection: .musics
                            )
                            self.vm.isFavorite = false
                            self.vm.success?()
                        } catch {
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                }
            }
            
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        let width = collectionView.frame.width
        let imageHeight = width * 0.6
        let titleHeight: CGFloat = vm.currentPlaylist?.playlistName == nil ? 0 : 28
        let stackHeight: CGFloat = 36
        let spacing: CGFloat = 16 + 8 + 8

        let totalHeight = imageHeight + titleHeight + stackHeight + spacing

        return CGSize(width: width, height: totalHeight)
    }
    
}



