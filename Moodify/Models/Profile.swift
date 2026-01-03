//
//  Profile.swift
//  Moodify
//
//  Created by Kenan Memmedov on 03.01.26.
//

import Foundation

struct Profile: ImageLabelProtocol {
    var titlText: String {
        fullName ?? ""
    }
    
    var imageName: String {
        imageString ?? ""
    }
    
    let fullName: String?
    let imageString: String?
}
