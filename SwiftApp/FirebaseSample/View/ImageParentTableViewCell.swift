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
        let nib = UINib(nibName: "TableViewInCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TableViewInCollection")
    }
    
    override func prepareForReuse() {
        //reuseするタイミングでDisposeBag()を更新
        //更新しない場合、上のDisposeBagに溜まっていってしまう。
        disposeBag = DisposeBag()
    }
}
