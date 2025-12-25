//
//  PodcastEndpoint.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.12.25.
//

import Foundation
enum PodcastEndpoint {
    case podcast(mood: String)
    
    var path: String {
        switch self {
        case .podcast(let mood):
            return NetworkingHelper.shared.getEndpointURL(with: "mood/podcasts?mood=\(mood)")
        }
    }
}
