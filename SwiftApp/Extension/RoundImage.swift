//
//  ImageView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/25.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation

extension RoundImage {
    func setRounded() {
        self.layer.borderWidth = 5
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
