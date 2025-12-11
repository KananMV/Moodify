//
//  UserFirestoreService.swift
//  Moodify
//
//  Created by Kenan Memmedov on 10.12.25.
//

import Foundation
protocol UserFirestoreService {
    func saveUser(uid: String, fullName: String) async throws 
}
