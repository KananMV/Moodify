

import FirebaseFirestore

final class FirestoreAdapter: UserFirestoreService {
    
    func saveUser(uid: String, fullName: String) async throws {
        let db = Firestore.firestore()
        let data = ["fullName": fullName]
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("users").document(uid).setData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
}
