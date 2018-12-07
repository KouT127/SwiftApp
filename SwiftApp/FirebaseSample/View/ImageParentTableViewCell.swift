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

class ImageParentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        collectionView.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        //reuseするタイミングでDisposeBag()を更新
        //更新しない場合、上のDisposeBagに溜まっていってしまう。
        disposeBag = DisposeBag()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        print(collectionView.bounds.height)
        print(collectionView.collectionViewLayout.collectionViewContentSize)
        collectionView.setNeedsLayout()
        print(collectionView.collectionViewLayout.collectionViewContentSize)
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
//        let size = CGSize(width: targetSize.width,
//                          height:)
        return  contentSize
        
    }
    
}
