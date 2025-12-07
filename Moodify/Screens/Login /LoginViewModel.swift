//
//  LoginViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.12.25.
//

import Foundation
class LoginViewModel {
    let authManager = AuthManager()
    
    func login(email: String, password: String) async throws{
        try await authManager.signIn(email: email, password: password)
    }
}
