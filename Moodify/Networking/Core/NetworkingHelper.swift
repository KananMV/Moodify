//
//  NetworkingHelper.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation

class NetworkingHelper {
    private let baseURL = "https://mood-backend-project.vercel.app/"
    
    
    static let shared = NetworkingHelper()
    
    func getEndpointURL(with path: String) -> String {
        baseURL + path
    }
    
    private init() {}
}
