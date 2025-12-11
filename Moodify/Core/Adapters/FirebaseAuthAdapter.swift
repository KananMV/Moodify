

import FirebaseAuth

final class FirebaseAuthAdapter: AuthService {
    
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
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume(returning: ())
            }
        }
    }
}
