//
//  AuthManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 07.12.25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    func signUp(email: String, password: String,fullName: String) async throws -> AuthDataResult  {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AuthDataResult, Error>) in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let result = result else {
                    fatalError("Unexpected nil result from Firebase Auth")
                }
                continuation.resume(returning: (result))
            }
            
        }
    }
    
    func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { _ , error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
}
