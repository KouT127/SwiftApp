//
//  CollectionViewCell.swift
//  SwiftApp
//
//  Created by kou on 2018/11/29.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class ImagesDisplaySectionCollectionCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func postImageDisplay(_ image: Single<ImageResponse>) {
        imageView.image = UIImage(named: "PlaceHolder")
        image.subscribe(onSuccess: { [weak self] response in
            self?.imageView.image = response.image
        }).disposed(by: disposeBag)
    }
}
