//
//  UserFavoritesService.swift
//  Moodify
//
//  Created by Kenan Memmedov on 08.01.26.
//

import Foundation

protocol UserFavoritesService {

    func addToFavorites<T: Codable>(
        playlist: CoreModel<[T]>,
        collection: FavoritesCollection
    ) async throws
    
    func fetchData<T: Codable>(
        collection: FavoritesCollection
    ) async throws -> [CoreModel<[T]>]
    
    func removeFromFavorites<T: Codable>(
        playlist: CoreModel<[T]>,
        collection: FavoritesCollection
    ) async throws
    
    func isFavorite(
        playlistId: String,
        collection: FavoritesCollection
    ) async throws -> Bool
}

enum FavoritesCollection: String {
    case musics
    case podcasts
}
