//
//  MusicUseCase.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.12.25.
//

import Foundation
protocol MusicUseCase {
    func getMusicURL(searchURL: String) async throws -> MusicURL?
}
