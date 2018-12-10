//
//  ImageParentTableViewCell.swift
//  SwiftApp
//
//  Created by kou on 2018/12/02.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ImageDetailSectionTwoCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ImageDetailSectionTwoCollection", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SectionTwoCollection")
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        let screenWidth = UIScreen.main.bounds.width
//        widthAnchor.constraint(equalToConstant: CGFloat(integerLiteral: 1000))
//        self.contentView.widthAnchor.constraint(equalToConstant: screenWidth)
        
//        let screenWidth = UIScreen.main.bounds.width
//        widthAnchor.constraint(equalToConstant:  screenWidth - (2 * 12))
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 0
//        }
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        //reuseするタイミングでDisposeBag()を更新
        //更新しない場合、上のDisposeBagに溜まっていってしまう。
        disposeBag = DisposeBag()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let size = CGSize(width: targetSize.width, height: contentSize.height)
        return  size
        
    }
}
