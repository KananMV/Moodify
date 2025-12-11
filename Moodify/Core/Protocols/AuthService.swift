//
//  AuthService.swift
//  Moodify
//
//  Created by Kenan Memmedov on 10.12.25.
//

import Foundation
protocol AuthService {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws -> String
}
