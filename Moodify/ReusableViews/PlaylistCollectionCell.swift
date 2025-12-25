//
//  PlaylistCollectionCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import UIKit
import Kingfisher

protocol PlaylistCollectionCellProtocol {
    var coverImageURL: String { get }
    var titleLabelText: String { get }
    var artistLabelText: String { get }
}

class PlaylistCollectionCell: UICollectionViewCell {
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        return image
    }()
    
    private let playImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .playButtonIcon
        return image
    }()
    
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(coverImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(playImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: 0.86),
            coverImage.widthAnchor.constraint(equalTo: coverImage.heightAnchor),
            coverImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            playImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playImage.heightAnchor.constraint(equalToConstant: 18),
            playImage.widthAnchor.constraint(equalToConstant: 18),
            
            titleLabel.topAnchor.constraint(equalTo: coverImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: playImage.leadingAnchor, constant: -24),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(playlist: PlaylistCollectionCellProtocol) {
        coverImage.kf.setImage(with: URL(string: playlist.coverImageURL))
        titleLabel.text = playlist.titleLabelText
        artistLabel.text = playlist.artistLabelText
    }
}
