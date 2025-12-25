//
//  PlaylistTabsCoordinator.swift
//  Moodify
//
//  Created by Kenan Memmedov on 24.12.25.
//

import UIKit

class PlaylistTabsCoordinator: Cordinator {
    var navigation: UINavigationController
    let mood: String

    init(navigation: UINavigationController, mood: String) {
        self.navigation = navigation
        self.mood = mood
    }

    func start() {
        let musicVC = MusicPlaylistController(
            vm: .init(playlistManager: MusicPlaylistManager(),
                      musicURLManager: MusicManager(),
                      mood: mood)
        )
        

        let podcastVC = PodcastPlaylistController(
            vm: .init(podcastManager: PodcastManager(),
                      moodText: mood)
        )

        let containerVC = PlaylistController(musicVC: musicVC, podcastVC: podcastVC)
        
        
        navigation.pushViewController(containerVC, animated: true)
        
    }
}
