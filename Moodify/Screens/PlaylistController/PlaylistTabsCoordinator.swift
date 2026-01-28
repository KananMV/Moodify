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
            vm: .init(
                playlistManager: MusicPlaylistManager(),
                      musicURLManager: MusicManager(),
                      mood: mood,
                      musicFavoritesService: FirestoreAdapter()
                     )
        )
        

        let podcastVC = PodcastPlaylistController(
            vm: .init(podcastManager: PodcastManager(),
                      moodText: mood, podcastFavoritesService: FirestoreAdapter())
        )

        let containerVC = PlaylistController(musicVC: musicVC, podcastVC: podcastVC)
        containerVC.hidesBottomBarWhenPushed = true
        navigation.pushViewController(containerVC, animated: true)
    }
}
