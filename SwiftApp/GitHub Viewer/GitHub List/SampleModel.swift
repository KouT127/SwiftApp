
//
//  SampleModel.swift
//  SwiftApp
//
//  Created by kou on 2018/08/20.
//  Copyright © 2018年 kou. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let login: String
    let url: URL
    let name: String?
    let email: String?
}

struct Repositories: Codable {
    let totalCount: Int
    let items: [Item]
    
    enum Keys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.items = try container.decode([Item].self, forKey: .items)
    }
}

struct Item: Codable {
    let name: String
    let fullName: String
    let owner: Owner
    let htmlUrl: String
    let description: String?
    let watchers: Int
    let language: String?
    
    enum Keys: String, CodingKey {
        case name, owner, description, watchers, language
        case fullName = "full_name"
        case htmlUrl = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.owner = try container.decode(Owner.self, forKey: .owner)
        self.htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
        self.description = try container.decode(String?.self, forKey: .description)
        self.watchers = try container.decode(Int.self, forKey: .watchers)
        self.language = try container.decode(String?.self, forKey: .language)
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String
    
    enum Keys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }
}
