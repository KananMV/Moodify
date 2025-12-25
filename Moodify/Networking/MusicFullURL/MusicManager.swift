//
//  MusicManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.12.25.
//

import Foundation

class MusicManager: MusicUseCase {
    let manager = NetworkManager()
    
    func getMusicURL(searchURL: String) async throws  -> MusicURL? {
        let params: [String: String] = [
            "youtubeSearchUrl": searchURL
        ]
        
        return try await manager.request(url: MusicEndpoint.search.path, method: .post, parameters: params, encoding: .json)
    }
}
