//
//  UserFireStorageService.swift
//  Moodify
//
//  Created by Kenan Memmedov on 02.01.26.
//

import Foundation

protocol UserFireStorageService {
    func uploadImage(imageData: Data) async throws -> String
}
