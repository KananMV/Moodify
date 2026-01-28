//
//  LibraryViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.01.26.
//

import Foundation

final class LibraryViewModel {
    var userFavoritesService: UserFavoritesService
    private(set) var musicFavorites: [CoreModel<[MusicPlaylist]>] = []
    private(set) var podcastFavorites: [CoreModel<[PodcastPlaylist]>] = []
    
    var currentCollection: FavoritesCollection = .musics
    
    init(userFavoritesService: UserFavoritesService) {
        self.userFavoritesService = userFavoritesService
    }
    
    func fetchFavorites(completion: @escaping () -> Void) {
        Task {
            do {
                switch currentCollection {
                case .musics:
                    let data: [CoreModel<[MusicPlaylist]>] = try await userFavoritesService.fetchData(collection: .musics)
                    self.musicFavorites = data
                case .podcasts:
                    let data: [CoreModel<[PodcastPlaylist]>] = try await userFavoritesService.fetchData(collection: .podcasts)
                    self.podcastFavorites = data
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to fetch favorites: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func changeCollection(to collection: FavoritesCollection, completion: @escaping () -> Void) {
        currentCollection = collection
        fetchFavorites(completion: completion)
    }
}
