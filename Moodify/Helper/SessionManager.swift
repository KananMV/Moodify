//
//  SessionManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 19.02.26.
//

import Foundation

enum SessionManager {
    static var uid: String? {
        UserDefaultsManager.shared.getDataString(key: .uid)
    }
    
    static func set(uid: String) {
        UserDefaultsManager.shared.saveDataString(value: uid, key: .uid)
    }
    
    static func clear() {
        UserDefaultsManager.shared.saveDataString(value: "", key: .uid)
    }
}
