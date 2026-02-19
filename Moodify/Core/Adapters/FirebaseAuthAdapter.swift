

import FirebaseAuth
import Foundation

final class FirebaseAuthAdapter: AuthService {
    func signInWithGoogle(tokens: GoogleTokens) async throws -> String {
        let credential = GoogleAuthProvider.credential(
            withIDToken: tokens.idToken,
            accessToken: tokens.accessToken
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credential) { result, error in
                if let error { continuation.resume(throwing: error); return }
                guard let uid = result?.user.uid else {
                    continuation.resume(throwing: NSError(domain: "No UID", code: 0)); return
                }
                SessionManager.set(uid: uid)
                continuation.resume(returning: uid)
            }
        }
    }
    
    
    
    func signUp(email: String, password: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let uid = result?.user.uid else {
                    continuation.resume(throwing: NSError(domain: "No UID", code: 0))
                    return
                }
                
                continuation.resume(returning: uid)
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if let uid = result?.user.uid {
                    SessionManager.set(uid: uid)
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume(returning: ())
            }
        }
    }
    
    func logout() async throws {
        try Auth.auth().signOut()
    }
}
