//
//  PodcastViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.12.25.
//

import Foundation
final class PodcastViewModel {
    let podcastManager: PodcastManager
    var moodText: String
    
    var items = [PodcastPlaylist]()
    
    init(podcastManager: PodcastManager,moodText: String) {
        self.podcastManager = podcastManager
        self.moodText = moodText
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getPodcasts() async {
        do {
            let data = try await podcastManager.getPodcasts(mood: moodText)
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

}
