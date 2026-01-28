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
    var musicFavoritesService: UserFavoritesService
    var moodText: String
    var playlistName: String?
    var searchURL: String?
    var playlistCoverImageURL: String?
    
    var items = [MusicPlaylist]()
    var currentPlaylist: CoreModel<[MusicPlaylist]>?
    
    var isFavorite: Bool = false
    
    init(playlistManager: MusicPlaylistUseCase, musicURLManager: MusicUseCase, mood: String, musicFavoritesService: UserFavoritesService) {
        self.playlistManager = playlistManager
        self.musicURLManager = musicURLManager
        self.moodText = mood
        self.musicFavoritesService = musicFavoritesService
    }
    
    init(
        playlist: CoreModel<[MusicPlaylist]>,
        musicURLManager: MusicUseCase,
        musicFavoritesService: UserFavoritesService
    ) {
        self.playlistManager = DummyPlaylistUseCase()
        self.musicURLManager = musicURLManager
        self.musicFavoritesService = musicFavoritesService
        self.moodText = playlist.playlistMood ?? ""
        self.items = playlist.playlist ?? []
        self.playlistCoverImageURL = playlist.playlistCoverImage
        self.currentPlaylist = playlist
        self.isFavorite = true
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getPlaylist() async {
        do {
            let data = try await playlistManager.getPlaylist(mood: moodText)
            Task { @MainActor in
                items = data?.playlist ?? []
                playlistCoverImageURL = data?.playlistCoverImage
                self.currentPlaylist = data
                success?()
            }
        } catch is CancellationError {
            return
        } catch {
            if Task.isCancelled { return }
            await MainActor.run {
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
    
    func toggleFavorite() {
        guard let playlist = currentPlaylist else { return }
        
        Task {
            do {
                if isFavorite {
                    try await musicFavoritesService.removeFromFavorites(
                        playlist: playlist,
                        collection: .musics
                    )
                } else {
                    try await musicFavoritesService.addToFavorites(
                        playlist: playlist,
                        collection: .musics
                    )
                }
                
                isFavorite.toggle()
                
                await MainActor.run {
                    self.success?()
                }
            } catch {
                await MainActor.run {
                    self.error?(error.localizedDescription)
                }
            }
        }
    }
    
    
}
final class DummyPlaylistUseCase: MusicPlaylistUseCase {
    func getPlaylist(mood: String) async throws -> CoreModel<[MusicPlaylist]>? {
        return nil
    }
}
