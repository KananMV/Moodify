//
//  ProfileImageNameLabelCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 26.12.25.
//

import UIKit

protocol ProfileImageNameLabelCellProtocol {
    var fullNameText: String { get }
    var imageURLString: String? { get }
}

class ProfileImageNameLabelCell: UITableViewCell {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tabbar
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(profileImage)
        view.clipsToBounds = false
        return view
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.text = "Kanan Mammadov"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layoutIfNeeded()
        imageContainer.layer.cornerRadius = imageContainer.frame.width / 2
        imageContainer.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageContainer)
        contentView.addSubview(fullNameLabel)
        
        backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.44),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            profileImage.topAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.trailingAnchor),
            profileImage.bottomAnchor.constraint(equalTo: imageContainer.layoutMarginsGuide.bottomAnchor),
            
            fullNameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 16),
            fullNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(data: ImageLabelProtocol) {
        fullNameLabel.text = data.titlText
        profileImage.loadImage(path: data.imageName)
    }
}
