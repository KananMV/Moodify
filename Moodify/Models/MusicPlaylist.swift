//
//  Playlist.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation

class MusicPlaylist: Codable, PlaylistCollectionCellProtocol{
    var coverImageURL: String {
        posterUrl ?? ""
    }
    
    var titleLabelText: String {
        title ?? ""
    }
    
    var artistLabelText: String {
        artist ?? ""
    }
    
    
    let title: String?
    let artist: String?
    let youtubeSearchUrl: String?
    let posterUrl: String?
    
}
