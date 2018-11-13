//
//  RoundButton.swift
//  SwiftApp
//
//  Created by kou on 2018/11/13.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
    @IBInspectable var conerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = conerRadius
    }
}

@IBDesignable class RoundImage: UIImageView {
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
    @IBInspectable var conerRadius: CGFloat = 0
    @IBInspectable var clipsToBound: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = conerRadius
        self.clipsToBounds = clipsToBound
    }
}
