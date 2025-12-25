//
//  PodcastUseCase.swift
//  Moodify
//
//  Created by Kenan Memmedov on 23.12.25.
//

import Foundation
protocol PodcastUseCase {
    func getPodcasts(mood: String) async throws  -> [PodcastPlaylist]?
}
