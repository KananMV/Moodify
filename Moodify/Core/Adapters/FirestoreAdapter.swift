

import FirebaseFirestore

final class FirestoreAdapter: UserFirestoreService, UserFavoritesService {
    
    func removeFromFavorites<T: Codable>(
        playlist: CoreModel<[T]>,
        collection: FavoritesCollection
    ) async throws {

        guard
            let uid = uid, !uid.isEmpty,
            let playlistId = playlist.playlistId, !playlistId.isEmpty
        else {
            throw NSError(domain: "InvalidData", code: 400)
        }

        try await db
            .collection("favorites")
            .document(uid)
            .collection(collection.rawValue)
            .document(playlistId)
            .delete()
    }
    
    func isFavorite(
        playlistId: String,
        collection: FavoritesCollection
    ) async throws -> Bool {

        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }

        let doc = try await db
            .collection("favorites")
            .document(uid)
            .collection(collection.rawValue)
            .document(playlistId)
            .getDocument()

        return doc.exists
    }
    
    func fetchData<T: Codable>(collection: FavoritesCollection) async throws -> [CoreModel<[T]>] {
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }
        
        let snapshot = try await db
            .collection("favorites")
            .document(uid)
            .collection(collection.rawValue)
            .getDocuments()
        
        var results: [CoreModel<[T]>] = []
        
        for doc in snapshot.documents {
            let playlistData = try doc.data(as: CoreModel<[T]>.self)
            results.append(playlistData)
        }
        
        return results
    }
    
    func addToFavorites<T: Codable>(playlist: CoreModel<[T]>, collection: FavoritesCollection) async throws {
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }

        let docRef = db
            .collection("favorites")
            .document(uid)
            .collection(collection.rawValue)
            .document(playlist.playlistId ?? "")

        let data = CoreModel(
            playlistId: playlist.playlistId,
            playlistCoverImage: playlist.playlistCoverImage,
            playlist: playlist.playlist,
            playlistMood: playlist.playlistMood,
            playlistName: playlist.playlistName
        )
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try docRef.setData(from: data) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    
    
    let db = Firestore.firestore()
    let uid = UserDefaultsManager.shared.getDataString(key: .uid)
    
    func getProfileData() async throws -> Profile {
        
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }
        
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
        
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }
        
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
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }
        
        let snapshot = try await db
            .collection("users")
            .document(uid)
            .getDocument()
        
        guard let data = snapshot.data(),
              let fullName = data["fullName"] as? String else { return ""}
        
        return fullName
    }
    
    func updateFullName(fullName: String) async throws  {
        
        guard let uid = uid, !uid.isEmpty else {
            throw NSError(domain: "AuthError", code: 401)
        }
        try await Firestore.firestore().collection("users").document(uid).updateData(["fullName": fullName])
    }
}
