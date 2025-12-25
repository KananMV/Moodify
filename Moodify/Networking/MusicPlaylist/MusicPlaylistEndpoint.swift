//
//  PlaylistEndpoint.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation
enum MusicPlaylistEndpoint {
    case playlists(mood: String)
    
    var path: String {
        switch self {
        case .playlists(let mood):
            return NetworkingHelper.shared.getEndpointURL(with: "mood/songs?mood=\(mood)") 
        }
    }
}
