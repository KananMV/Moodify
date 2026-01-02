//
//  FireStorageAdapter.swift
//  Moodify
//
//  Created by Kenan Memmedov on 02.01.26.
//

import Foundation
import FirebaseStorage

final class FireStorageAdapter: UserFireStorageService {
    
    func uploadImage(imageData: Data) async throws -> String {
        let storage = Storage.storage()
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else { return ""}
        
        let ref = storage.reference()
                    .child("profile_images")
                    .child("\(uid)")
        
        _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
