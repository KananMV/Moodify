//
//  PlaylistUseCase.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation
protocol MusicPlaylistUseCase {
    func getPlaylist(mood: String) async throws -> [MusicPlaylist]?
}
