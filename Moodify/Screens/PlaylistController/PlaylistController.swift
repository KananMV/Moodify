
import UIKit

final class PlaylistController: UIViewController {

    private let musicVC: UIViewController
    private let podcastVC: UIViewController

    private let headerView = UIView()
    private let containerView = UIView()

    private lazy var pillSegment: PillSegmentedControl = {
        let s = PillSegmentedControl()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.items = ["Music", "Podcasts"]
        s.setSelectedIndex(0, animated: false)
        s.onChange = { [weak self] index in
            guard let self else { return }
            let target = index == 0 ? self.musicVC : self.podcastVC
            self.show(target, animated: true)
        }
        return s
    }()

    private var currentVC: UIViewController?

    init(musicVC: UIViewController, podcastVC: UIViewController) {
        self.musicVC = musicVC
        self.podcastVC = podcastVC
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .controllerBack

        setupHeader()
        setupContainer()

        show(musicVC, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        navigationController?.setViewControllers([HomeController(), self], animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isHidden = false
    }


    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        headerView.addSubview(pillSegment)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pillSegment.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            pillSegment.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            pillSegment.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            pillSegment.heightAnchor.constraint(equalToConstant: 52),
            pillSegment.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
        ])
    }

    private func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func show(_ vc: UIViewController, animated: Bool) {
        guard currentVC !== vc else { return }

        if vc.parent == nil {
            addChild(vc)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(vc.view)
            NSLayoutConstraint.activate([
                vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            vc.didMove(toParent: self)
            vc.view.isHidden = true
            vc.view.alpha = 0
        }

        let old = currentVC
        currentVC = vc
        vc.view.isHidden = false

        guard animated else {
            old?.view.isHidden = true
            old?.view.alpha = 0
            vc.view.alpha = 1
            return
        }

        UIView.animate(withDuration: 0.2) {
            old?.view.alpha = 0
            vc.view.alpha = 1
        } completion: { _ in
            old?.view.isHidden = true
        }
    }
}
