import UIKit
import Lottie
import SafariServices

final class MusicPlaylistController: BaseViewController {

    private var animationView: LottieAnimationView?
    private var loaderOverlay: UIView?

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
            self?.hideLoader()
            self?.showAlert(title: "Error", message: error)
        }

        Task { @MainActor in
            showLoader()
            defer { hideLoader() }
            await vm.getPlaylist()
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
    
    private func showLoader() {
        guard loaderOverlay == nil else { return }

        let hostView: UIView
        if let window = view.window {
            hostView = window
        } else if let navView = navigationController?.view {
            hostView = navView
        } else {
            hostView = view
        }

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        overlay.isUserInteractionEnabled = true

        let animation = LottieAnimationView(name: "Sparkles Loop Loader ai")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop

        overlay.addSubview(animation)
        hostView.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: hostView.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: hostView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: hostView.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: hostView.bottomAnchor),

            animation.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            animation.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            animation.widthAnchor.constraint(equalToConstant: 200),
            animation.heightAnchor.constraint(equalToConstant: 200)
        ])

        animation.play()
        
        loaderOverlay = overlay
        animationView = animation
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
        animationView = nil

        loaderOverlay?.removeFromSuperview()
        loaderOverlay = nil
    }
}

extension MusicPlaylistController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.items.count
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
    
}
