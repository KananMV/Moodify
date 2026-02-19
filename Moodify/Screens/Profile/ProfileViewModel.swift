//
//  ProfileViewModel.swift
//  Moodify
//
//  Created by Kenan Memmedov on 31.12.25.
//

import Foundation

enum ProfileSectionType {
    case profile, options
}

struct ProfileSection {
    let sectionType: ProfileSectionType
    var items: [ProfileOptionsModel]
    let footerHeight: CGFloat
}

final class ProfileViewModel {
    private let authService: AuthService
    private let firestoreService: UserFirestoreService
    var profile: Profile?
    
    var sections: [ProfileSection] = [.init(sectionType: .profile, items:[.init(icon: "", text: "", type: .none)], footerHeight: 0),
                                      .init(sectionType: .options,
                                            items: [
                                                .init(icon: "person.fill", text: "Profile", type: .profile),
                                                .init(icon: "book.fill", text: "Terms of service", type: .termsOfService),
                                                .init(icon: "checkmark.shield.fill", text: "Privacy", type: .privacyPolicy)],
                                            footerHeight: 12
                                           )
    ]
    
    init(authService: AuthService, firestoreService: UserFirestoreService) {
        self.authService = authService
        self.firestoreService = firestoreService
    }
    
    func getProfileData() async throws {
        profile = try await firestoreService.getProfileData()
        guard let profile else { return }
        sections[0].items = [.init(icon: profile.imageString ?? "", text: profile.fullName ?? "", type: nil)]
    }
    
    func logout() async throws {
        try await authService.logout()
        SessionManager.clear()
        UserDefaultsManager.shared.removeData(key: .isLoginWithGoogle)
        
    }
}
