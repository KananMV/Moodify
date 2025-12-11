//
//  LoginViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.12.25.
//

import Foundation
class LoginViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login(email: String, password: String) async throws{
        try await authService.signIn(email: email, password: password)
    }
}
