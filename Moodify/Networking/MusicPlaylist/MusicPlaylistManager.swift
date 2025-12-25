//
//  PlaylistManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation
class MusicPlaylistManager: MusicPlaylistUseCase {
    
    let manager = NetworkManager()
    
    func getPlaylist(mood: String) async throws -> [MusicPlaylist]? {
        return try await manager.request(url: MusicPlaylistEndpoint.playlists(mood: mood).path, method: .get)
    }
}
