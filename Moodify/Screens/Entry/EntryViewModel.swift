//
//  EntryViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.02.26.
//

import Foundation

final class EntryViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signInWithGoogle(getUserInfo: @escaping () async throws -> GoogleUserInfo) async throws -> (uid: String, info: GoogleUserInfo) {
            let info = try await getUserInfo()
            let tokens = GoogleTokens(idToken: info.idToken, accessToken: info.accessToken)

            let uid = try await authService.signInWithGoogle(tokens: tokens)
            return (uid, info)
        }
    
    
}
