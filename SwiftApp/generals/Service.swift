//
//  APIManeger.swift
//  SwiftApp
//
//  Created by kou on 2018/10/22.
//  Copyright © 2018 kou. All rights reserved.
//

import Moya

enum Service {
    case searchRepo(String)
    case user(String)
}

extension Service: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .searchRepo(let query):
            return "/search/users/"
        case .user(let name):
            return "/users/\(name.urlEscaped)"
        }
    }
    var method: Moya.Method {
        
        return .get
    }
    var task: Task {
        switch self {
        case .searchRepo(_):
            return .requestPlain
        case .user(_):
            return .requestPlain
        }
    }
    var headers: [String : String]? { return nil }
    
    // Mock
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
