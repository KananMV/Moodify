//
//  FireStorageAdapter.swift
//  Moodify
//
//  Created by Kenan Memmedov on 02.01.26.
//

import Foundation
import FirebaseStorage

final class FireStorageAdapter: UserFireStorageService {
    private let storage = Storage.storage()
    
    func deleteImage(downloadURL: String) async throws {
        guard let url = URL(string: downloadURL) else { return }
        let reference = storage.reference(forURL: url.absoluteString)
        try await reference.delete()

    }

    func uploadImage(imageData: Data) async throws -> String {
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else { return ""}
        
        let ref = storage.reference()
                    .child("profile_images")
                    .child("\(uid)")
        
        _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
