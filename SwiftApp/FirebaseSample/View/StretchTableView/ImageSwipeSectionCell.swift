//
//  ImageDetailSectionThreeCell.swift
//  SwiftApp
//
//  Created by kou on 2018/12/10.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ImageSwipeSectionCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ImageSwipeSectionCollection", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageSwipeSectionCollectionCell")
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.isScrollEnabled = true
    }
    
    override func prepareForReuse() {
        //reuseするタイミングでDisposeBag()を更新
        //更新しない場合、上のDisposeBagに溜まっていってしまう。
        disposeBag = DisposeBag()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let size = CGSize(width: contentSize.width, height: targetSize.height)
        return  size
    }
}
