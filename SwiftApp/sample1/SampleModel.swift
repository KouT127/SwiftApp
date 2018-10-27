
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
