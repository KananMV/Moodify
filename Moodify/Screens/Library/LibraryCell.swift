//
//  LibraryCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.01.26.
//

import UIKit

final class LibraryCell: UICollectionViewCell {
    
    private let coverContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var imageViews: [UIImageView] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViews.forEach { $0.image = nil }
        titleLabel.text = nil
    }
    
    private func setupUI() {
        contentView.addSubview(coverContainerView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            coverContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverContainerView.heightAnchor.constraint(equalTo: coverContainerView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: coverContainerView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
        
        setupImageGrid()
    }
    
    private func setupImageGrid() {
        let grid = UIStackView()
        grid.axis = .vertical
        grid.distribution = .fillEqually
        grid.spacing = 1
        grid.translatesAutoresizingMaskIntoConstraints = false
        
        coverContainerView.addSubview(grid)
        
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: coverContainerView.topAnchor),
            grid.leadingAnchor.constraint(equalTo: coverContainerView.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: coverContainerView.trailingAnchor),
            grid.bottomAnchor.constraint(equalTo: coverContainerView.bottomAnchor)
        ])
        
        for _ in 0..<2 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 1
            
            for _ in 0..<2 {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.backgroundColor = .secondarySystemBackground
                imageViews.append(imageView)
                row.addArrangedSubview(imageView)
            }
            
            grid.addArrangedSubview(row)
        }
    }
    
    func configure(title: String, coverURLs: [String]) {
        titleLabel.text = title
        
        for (index, urlString) in coverURLs.prefix(4).enumerated() {
            imageViews[index].loadImage(path: urlString)
        }
    }
}
