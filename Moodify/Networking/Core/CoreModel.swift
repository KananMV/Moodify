//
//  CoreModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.01.26.
//

import Foundation

struct CoreModel <T: Codable>: Codable {
    let playlistCoverImage: String?
    let playlist: T?
}
