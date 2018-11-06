//
//  Message.swift
//  SwiftApp
//
//  Created by kou on 2018/11/05.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit

//private struct LocationItem: LocationItem {
//
//    var location: CLLocation
//    var size: CGSize
//
//    init(location: CLLocation) {
//        self.location = location
//        self.size = CGSize(width: 240, height: 240)
//    }
//}

//private struct Media: MediaItem {
//
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//
//    init(image: UIImage) {
//        self.image = image
//        self.size = CGSize(width: 240, height: 240)
//        self.placeholderImage = UIImage()
//    }
//}
struct Room {
    var roomName: String
    var id: String
}

struct Message: MessageType {
    var sentDate: Date
    var messageId: String
    var content: String
    var sender: Sender
    var kind: MessageKind
    
    init(kind: MessageKind, sender: Sender, messageId: String, content: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.content = content
        self.sentDate = date
    }

//    init(text: String, sender: Sender, messageId: String, date: Date) {
//        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
//    }
//
//    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
//        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
//    }

//    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
//        let mediaItem = Media(image: image)
//        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
//    }
//
//    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
//        let mediaItem = Media(image: thumbnail)
//        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
//    }
//
//    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
//        let locationItem = MockLocationItem(location: location)
//        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
//    }
//
//    init(emoji: String, sender: Sender, messageId: String, date: Date) {
//        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
//    }
}
