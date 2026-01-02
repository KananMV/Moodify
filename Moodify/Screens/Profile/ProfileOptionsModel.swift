//
//  ProfileOptionsModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 29.12.25.
//

import Foundation
struct ProfileOptionsModel: LeftImageCenterLabelCellDelegate {
    var image: String {
        icon
    }
    
    var labelText: String {
        text
    }
    
    let icon: String
    let text: String
}
