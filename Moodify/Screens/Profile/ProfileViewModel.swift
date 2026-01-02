//
//  ProfileViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 31.12.25.
//

import Foundation

final class ProfileViewModel {
    private let authService: AuthService
    private let firestoreService: UserFirestoreService
    var profile: Profile?
    
    init(authService: AuthService, firestoreService: UserFirestoreService) {
        self.authService = authService
        self.firestoreService = firestoreService
    }
    
    func getProfileData() async throws {
        profile =  try await firestoreService.getProfileData()
    }
    
    func logout() async throws {
        try await authService.logout()
    }
}
