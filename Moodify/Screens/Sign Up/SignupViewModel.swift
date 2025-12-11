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
    
    private let auth: AuthService
    private let userDB: UserFirestoreService
    
    init(auth: AuthService, userDB: UserFirestoreService) {
        self.auth = auth
        self.userDB = userDB
    }
    
    func register(fullName: String, email: String, password: String) async throws {
        let uid = try await auth.signUp(email: email, password: password)
        try await userDB.saveUser(uid: uid, fullName: fullName)
    }
    
    func signUp(email: String, password: String,fullName: String) async throws {
        let result = try await authManager.signUp(email: email, password: password, fullName: fullName)
        try await firestoreManager.saveUserData(uid: result.user.uid, fullName: fullName)
    }
}
