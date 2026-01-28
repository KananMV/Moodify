//
//  PodcastViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.12.25.
//

import Foundation
final class PodcastViewModel {
    let podcastManager: PodcastManager?
    var moodText: String
    var playlistCoverImageURL: String?
    var podcastFavoritesService: UserFavoritesService
    var playlistName: String?
    
    var items = [PodcastPlaylist]()
    
    init(podcastManager: PodcastManager,moodText: String, podcastFavoritesService: UserFavoritesService) {
        self.podcastManager = podcastManager
        self.moodText = moodText
        self.podcastFavoritesService = podcastFavoritesService
    }
    
    init(
        playlist: CoreModel<[PodcastPlaylist]>,
        podcastFavoritesService: UserFavoritesService
    ) {
        self.podcastManager = nil
        self.podcastFavoritesService = podcastFavoritesService
        self.moodText =  playlist.playlistMood ?? ""
        self.items = playlist.playlist ?? []
        self.playlistCoverImageURL = playlist.playlistCoverImage
        self.currentPlaylist = playlist
        self.isFavorite = true
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    var currentPlaylist: CoreModel<[PodcastPlaylist]>?
    var isFavorite: Bool = false
    
    func getPodcasts() async {
        guard let podcastManager else { return }
        
        do {
            let data = try await podcastManager.getPodcasts(mood: moodText)
            await MainActor.run {
                items = data?.playlist ?? []
                currentPlaylist = data
                playlistName = data?.playlistName
                playlistCoverImageURL = data?.playlistCoverImage
                success?()
            }
        } catch {
            await MainActor.run {
                self.error?(error.localizedDescription)
            }
        }
    }
    
    func toggleFavorite() {
        guard let playlist = currentPlaylist else { return }
        
        Task {
            do {
                if isFavorite {
                    try await podcastFavoritesService.removeFromFavorites(
                        playlist: playlist,
                        collection: .podcasts
                    )
                } else {
                    try await podcastFavoritesService.addToFavorites(
                        playlist: playlist,
                        collection: .podcasts
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
