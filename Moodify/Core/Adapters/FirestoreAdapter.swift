

import FirebaseFirestore
import FirebaseStorage

final class FirestoreAdapter: UserFirestoreService {
    func getProfileData() async throws -> Profile {
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else {
            return Profile(fullName: nil, imageString: nil)
        }
        
        let db = Firestore.firestore()
        let snapshot = try await db
            .collection("users")
            .document(uid)
            .getDocument()
        
        guard let data = snapshot.data() else {
            fatalError("Failed to get document data")
        }
        
        let fullName = data["fullName"] as? String ?? ""
        let imageURLString = data["imageURL"] as? String ?? ""
        
        return Profile(fullName: fullName, imageString: imageURLString)
    }
    
    
    func updateImageURL(url: String) async throws {
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else { return }
        
        let db = Firestore.firestore()
        try await db
            .collection(
                "users"
            )
            .document(
                uid
            )
            .updateData(
                ["imageURL": url]
            )
    }
    
    
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
    
    func getFullName() async throws -> String {
        
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else { return ""}
        
        let db = Firestore.firestore()
        let snapshot = try await db
                .collection("users")
                .document(uid)
                .getDocument()
        
        guard let data = snapshot.data(),
              let fullName = data["fullName"] as? String else { return ""}
        
        return fullName
    }
    
    func updateFullName(fullName: String) async throws  {
        guard let uid = UserDefaultsManager.shared.getDataString(key: .uid) else { return }
        try await Firestore.firestore().collection("users").document(uid).updateData(["fullName": fullName])
    }
    
    
}
