//
//  ImageSection.swift
//  SwiftApp
//
//  Created by kou on 2018/12/02.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionedImageViewState {
    var sections: [ImageSection]
    init(sections: [ImageSection]) {
        self.sections = sections
    }
}

//Section
struct ImageSection: AnimatableSectionModelType {
    
    var header: String
    var contents: [ImageContent]
    var updated: Date
    
    typealias Item = ImageContent
    typealias Identity = String
    
    init(header: String, contents: [ImageContent], updated: Date) {
        self.header = header
        self.contents = contents
        self.updated = updated
    }
    
    var identity: String {
        return header
    }
    
    var items: [ImageContent] {
        return contents
    }
    
    init(original: ImageSection, items: [Item]) {
        self = original
        self.contents = items
    }
}

//Section内の内容
struct ImageContent: IdentifiableType, Equatable  {
    let imageId: String
    let mainImageUrl: String
    let userName: String
    let userImageUrl: String
    let imageDescription: String
    let date: Date
    
    typealias Identity = String
    
    var identity: String {
        return imageId
    }
    
    init(imageId: String, mainImageUrl: String, userName: String, userImageUrl: String, imageDescription: String, date: Date) {
        self.imageId = imageId
        self.mainImageUrl = mainImageUrl
        self.userName = userName
        self.userImageUrl = userImageUrl
        self.imageDescription = imageDescription
        self.date = date
    }
}

// equatable, this is needed to detect changes
func == (lhs: ImageContent, rhs: ImageContent) -> Bool {
    return lhs.imageId == rhs.imageId && lhs.date == rhs.date
}

// MARK: Some nice extensions
extension ImageContent: CustomDebugStringConvertible {
    var debugDescription: String {
        return "ImageContent(number: \(imageId), date: \(date.timeIntervalSince1970))"
    }
}

extension ImageContent: CustomStringConvertible {
    var description: String {
        return "\(imageId)"
    }
}

func == (lhs: ImageSection, rhs: ImageSection) -> Bool {
    return lhs.header == rhs.header && lhs.contents == rhs.contents && lhs.updated == rhs.updated
}
