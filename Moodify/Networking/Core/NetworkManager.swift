//
//  NetworkManager.swift
//  Moodify
//
//  Created by Kenan Memmedov on 16.12.25.
//

import Foundation
import Alamofire

enum EncodingType {
    case json, url
    
    var encoding: ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        case .url:
            return URLEncoding.default
        }
    }
}

final class NetworkManager {
    func request <T: Codable> (url: String,
                                method: HTTPMethod,
                                parameters: Parameters? = nil,
                                encoding: EncodingType = .url) async throws -> T? {
        return try await AF.request(url,method: method,parameters: parameters,encoding: encoding.encoding).serializingDecodable(T.self).value
    }
}
