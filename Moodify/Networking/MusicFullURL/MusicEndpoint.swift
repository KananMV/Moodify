//
//  MusicEndpoint.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.12.25.
//

import Foundation
enum MusicEndpoint {
    case search
    
    var path: String {
        switch self {
        case .search:
            return NetworkingHelper.shared.getEndpointURL(with: "resolve/music-url")
        }
    }
}
