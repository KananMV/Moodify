//
//  Podcast.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.12.25.
//

import Foundation

struct PodcastPlaylist: Codable, PlaylistCollectionCellProtocol {
    var coverImageURL: String {
        artworkUrl ?? ""
    }
    
    var titleLabelText: String {
        title ?? ""
    }
    
    var artistLabelText: String {
        author ?? ""
    }
    
    let collectionId: Int?
    let title: String?
    let author: String?
    let artworkUrl: String?
    let trackViewUrl: String?
    let feedUrl: String?
}
