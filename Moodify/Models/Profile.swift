//
//  Profile.swift
//  Moodify
//
//  Created by Kenan Memmedov on 03.01.26.
//

import Foundation
struct Profile: ProfileImageNameLabelCellProtocol {
    var fullNameText: String {
        fullName ?? ""
    }
    
    var imageURLString: String? {
        imageString
    }
    
    let fullName: String?
    let imageString: String?
}
