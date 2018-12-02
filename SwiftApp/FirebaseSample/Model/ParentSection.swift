//
//  ImageSection.swift
//  SwiftApp
//
//  Created by kou on 2018/11/29.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionedParentViewState {
    var sections: [ParentSection]
    init(sections: [ParentSection]) {
        self.sections = sections
    }
}

//Section
struct ParentSection: AnimatableSectionModelType {
    var header: String
    var contents: [Content]
    var updated: Date
    
    typealias Item = Content
    typealias Identity = String
    
    init(header: String, contents: [Content], updated: Date) {
        self.header = header
        self.contents = contents
        self.updated = updated
    }
    
    var identity: String {
        return header
    }
    
    var items: [Content] {
        return contents
    }
    
    init(original: ParentSection, items: [Item]) {
        self = original
        self.contents = items
    }
}

//Section内の内容
struct Content: IdentifiableType, Equatable  {
    let contentId: String
    let headerSection: [ImageSection]
    let imageSection: [ImageSection]
    let date: Date
    
    typealias Identity = String
    
    var identity: String {
        return contentId
    }
    
    init(contentId: String, headerSection: [ImageSection], imageSection: [ImageSection], date: Date) {
        self.contentId = contentId
        self.headerSection = headerSection
        self.imageSection = imageSection
        self.date = date
    }
}

// equatable, this is needed to detect changes
func == (lhs: Content, rhs: Content) -> Bool {
    return lhs.contentId == rhs.contentId && lhs.date == rhs.date
}

// MARK: Some nice extensions
extension Content: CustomDebugStringConvertible {
    var debugDescription: String {
        return "ImageContent(number: \(contentId), date: \(date.timeIntervalSince1970))"
    }
}

extension Content: CustomStringConvertible {
    var description: String {
        return "\(contentId)"
    }
}

func == (lhs: ParentSection, rhs: ParentSection) -> Bool {
    return lhs.header == rhs.header && lhs.contents == rhs.contents && lhs.updated == rhs.updated
}
