//
//  CoreModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.01.26.
//

import Foundation

struct CoreModel <T: Codable>: Codable {
    let playlistId: String?
    let playlistCoverImage: String?
    let playlist: T?
    
    let playlistMood: String?
    let playlistName: String?
}
