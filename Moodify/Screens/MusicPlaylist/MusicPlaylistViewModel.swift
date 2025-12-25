//
//  PlaylistViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation


final class MusicPlaylistViewModel {
    
    var playlistManager: MusicPlaylistUseCase
    var musicURLManager: MusicUseCase
    var moodText: String
    var searchURL: String?
    
    var items = [MusicPlaylist]()
    
    init(playlistManager: MusicPlaylistUseCase,musicURLManager: MusicUseCase,mood: String) {
        self.playlistManager = playlistManager
        self.musicURLManager = musicURLManager
        self.moodText = mood
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getPlaylist() async {
        do {
            let data = try await playlistManager.getPlaylist(mood: moodText)
            Task { @MainActor in
                items = data ?? []
                success?()
            }
        } catch {
            Task { @MainActor in
                self.error?(error.localizedDescription)
            }
           
        }
    }
    
    func getMusicURL(musicURL: String) async -> String? {
        do {
            let data = try await musicURLManager.getMusicURL(searchURL: musicURL)
            return data?.youtubeUrl
        } catch {
            Task { @MainActor in
                self.error?(error.localizedDescription)
            }
            return nil
        }
    }
    
    
}
