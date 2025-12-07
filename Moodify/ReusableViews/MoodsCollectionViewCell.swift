//
//  MoodsCollectionViewCell.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.12.25.
//

import UIKit

class MoodsCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.secondButton.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            
        ])
    }
    
    func configure(emotion: EmotionType) {
        label.text = emotion.titleOnly
    }
    
    func setSelectedState(_ isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = .button
            containerView.layer.borderColor = UIColor.clear.cgColor
            label.textColor = .white
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor.secondButton.cgColor
            label.textColor = .label
        }
    }
    
}
