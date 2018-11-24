//
//  Date.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation

extension Date {
    func toString(_ format: String = "yyyy/MM/dd", timeZone: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if timeZone {
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
        }
        
        return formatter.string(from: self)
    }
}
