//
//  ProfileOptionsModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 29.12.25.
//

import Foundation

enum ProfileOptionsModelType {
    case profile
    case termsOfService
    case privacyPolicy
}

struct ProfileOptionsModel: ImageLabelProtocol {
    var imageName: String {
        icon
    }
    
    var titlText: String {
        text
    }
    
    let icon: String
    let text: String
    let type: ProfileOptionsModelType?
}
