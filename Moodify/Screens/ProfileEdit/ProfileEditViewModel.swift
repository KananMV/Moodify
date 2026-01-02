//
//  ProfileEditViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 01.01.26.
//

import Foundation

final class ProfileEditViewModel {
    let fullName: String
    var profileImage: Data
    let userFireStoreService: UserFirestoreService
    let userFireStorageService: UserFireStorageService
    
    init(fullName: String, userFireStoreService: UserFirestoreService, userFireStorageService: UserFireStorageService, profileImage: Data) {
        self.fullName = fullName
        self.userFireStoreService = userFireStoreService
        self.userFireStorageService = userFireStorageService
        self.profileImage = profileImage
    }
    
    func updateFullName(_ newFullName: String) async throws {
        try await userFireStoreService.updateFullName(fullName: newFullName)
    }
    
    func uploadImageData(_ imageData: Data) async throws -> String {
        try await userFireStorageService.uploadImage(imageData: imageData)
    }
    
    func updateProfileImageURL(_ profileImageURL: String) async throws {
        try await userFireStoreService.updateImageURL(url: profileImageURL)
    }
    
    
}
