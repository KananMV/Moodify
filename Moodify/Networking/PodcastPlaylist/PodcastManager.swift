//
//  PodcastManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.12.25.
//

import Foundation
class PodcastManager: PodcastUseCase {
    let manager = NetworkManager()
    
    func getPodcasts(mood: String) async throws -> [PodcastPlaylist]? {
        return try await manager.request(url: PodcastEndpoint.podcast(mood: mood).path, method: .get)
    }
}
