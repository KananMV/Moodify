//
//  SignupViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.12.25.
//

import Foundation

class SignupViewModel {
    let authManager = AuthManager()
    let firestoreManager = FireStoreManager()
    
    func signUp(email: String, password: String,fullName: String) async throws {
        let result = try await authManager.signUp(email: email, password: password, fullName: fullName)
        try await firestoreManager.saveUserData(uid: result.user.uid, fullName: fullName)
    }
}
