import UIKit

final class PlaylistCoverHeader: UICollectionReusableView {

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()

    private let moodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [moodView, saveButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var moodView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .secondButton
        view.addSubview(moodLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.baseBackgroundColor = .button
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 14, weight: .bold)
            return outgoing
        }
        
        let button = UIButton(configuration: config)
        button.isHidden = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setSaved(_ saved: Bool) {
        isSaved = saved
    }
    
    private var isSaved: Bool = false {
        didSet {
            let title = isSaved ? "Saved" : "Save"
            let backColor = isSaved ? UIColor.secondButton: .button
            let image = isSaved ? UIImage(systemName: "checkmark"): UIImage(systemName: "plus")
            saveButton.setTitle(title, for: .normal)
            saveButton.configuration?.baseBackgroundColor = backColor
            saveButton.configuration?.image = image
        }
    }

    var buttonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(stackView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 36),

            moodLabel.centerXAnchor.constraint(equalTo: moodView.centerXAnchor),
            moodLabel.centerYAnchor.constraint(equalTo: moodView.centerYAnchor)
        ])
    }
    
    @objc private func saveButtonTapped() {
        buttonTapped?()
    }

    func configure(with base64String: String,
                   mood: String,
                   titleLabelText: String?) {

        imageView.loadImage(base64String: base64String)
        moodLabel.text = "Mood: \(mood)"

        if let title = titleLabelText, !title.isEmpty {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        saveButton.isHidden = false
        stackView.isHidden = false
    }
}
