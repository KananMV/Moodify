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
        guard let path = path, !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let url = URL(string: path) else {
            self.image = imageData ?? UIImage(systemName: "person.fill")
            return
        }
        
        kf.setImage(with: url)
    }
    
    func loadImage(base64String: String) {
            DispatchQueue.global(qos: .userInitiated).async {
                var imageData: Data?

                if base64String.hasPrefix("data:image/") {
                    guard let commaIndex = base64String.firstIndex(of: ",") else { return }
                    let pureBase64 = String(base64String[base64String.index(after: commaIndex)...])
                    imageData = Data(base64Encoded: pureBase64)
                } else {
                    imageData = Data(base64Encoded: base64String)
                }

                guard let data = imageData, let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
}
