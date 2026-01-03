//
//  UIImageView+Extension.swift
//  MovieApp
//
//  Created by Shamkhal Guliyev on 02.10.25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(path: String? = nil, imageData: UIImage? = nil) {
        if let url = URL(string: path ?? "") {
            kf.setImage(with: url)
        } else {
            self.image = imageData
        }
    }
}
