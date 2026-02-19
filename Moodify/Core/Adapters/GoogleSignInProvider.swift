//
//  GoogleSignInProvider.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.02.26.
//

import UIKit
import GoogleSignIn
import FirebaseCore

protocol GoogleSignInProviding {
    func signIn(presenting: UIViewController) async throws -> GoogleUserInfo
    func signOut()
}

@MainActor
final class GoogleSignInProvider: GoogleSignInProviding {

    func signIn(presenting: UIViewController) async throws -> GoogleUserInfo {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "GoogleSignInProvider", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing Firebase clientID"])
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)

        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "GoogleSignInProvider", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Missing idToken"])
        }

        let accessToken = result.user.accessToken.tokenString
        let fullName = result.user.profile?.name
        let email = result.user.profile?.email
        let photoURL = result.user.profile?.imageURL(withDimension: 256)?.absoluteString

        return GoogleUserInfo(
            idToken: idToken,
            accessToken: accessToken,
            fullName: fullName,
            email: email,
            photoURL: photoURL
        )
    }

    nonisolated func signOut() {
        Task { @MainActor in
            GIDSignIn.sharedInstance.signOut()
        }
    }
}
