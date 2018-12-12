//
//  imageDetailSectionThreeCollectionCell.swift
//  SwiftApp
//
//  Created by kou on 2018/12/10.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxNuke
import Nuke

class ImageSwipeSectionCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func imageDisplay(_ image: Single<ImageResponse>) {
        imageView.image = UIImage(named: "PlaceHolder")
        image.subscribe(onSuccess: { [weak self] response in
            self?.imageView.image = response.image
        }).disposed(by: disposeBag)
    }
}
