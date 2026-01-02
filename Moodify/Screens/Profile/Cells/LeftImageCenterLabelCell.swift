//
//  AccountDetailsCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 26.12.25.
//

import UIKit

protocol LeftImageCenterLabelCellDelegate {
    var image: String { get }
    var labelText: String { get }
}
class LeftImageCenterLabelCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addSubview(imageContainer)
        view.addSubview(rightImage)
        view.addSubview(label)
        view.layer.cornerRadius = 20
        view.backgroundColor = .tabbar
        return view
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondButton
        view.addSubview(leftImage)
        view.clipsToBounds = true
        return view
    }()
    
    private let leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let rightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        backgroundColor = .clear
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layoutIfNeeded()
        imageContainer.layer.cornerRadius = imageContainer.frame.width / 2
        imageContainer.clipsToBounds = true
    }
    
    private func setupConstraints() {
        let constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            leftImage.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            leftImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -8),
            leftImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 8),
            leftImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            
            imageContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 44),
            imageContainer.heightAnchor.constraint(equalToConstant: 44),
            
            rightImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 8),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(data: LeftImageCenterLabelCellDelegate) {
        leftImage.image = UIImage(systemName: data.image)
        label.text = data.labelText
    }
    
    
}
