//
//  APIManeger.swift
//  SwiftApp
//
//  Created by kou on 2018/10/22.
//  Copyright © 2018 kou. All rights reserved.
//



import Moya

enum GitHub {
    case userProfile(String)
    case repositories(String)
}

extension GitHub: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .repositories:
            return "/search/repositories"
        }
    }
//    var parameters: [String: String]? {
//        switch self {
//        case .repositories(let query):
//            var params: [String : String] = [:]
//            params["q"] = query
//            return params
//        default:
//            return nil
//        }
//    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case .userProfile(_):
            return .requestPlain
        case .repositories(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? { return nil }
    
    // Mock
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        print(FileHandle(forReadingAtPath: path)!.readDataToEndOfFile())
        return Data()
    }
}

private extension String {
    var urlEscaped: String {
        print(self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
