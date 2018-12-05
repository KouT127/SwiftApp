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

class ImageCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func postImageDisplay(_ image: Single<ImageResponse>) {
        imageView.image = UIImage(named: "PlaceHolder")
        // Load an image and display the result on success.
        image.subscribe(onSuccess: { [weak self] response in
            self?.imageView.image = response.image
        }).disposed(by: disposeBag)
    }
    
    func userImageDisplay(_ image: Single<ImageResponse>) {
        imageView.image = UIImage(named: "PlaceHolder")
        // Load an image and display the result on success.
        image.subscribe(onSuccess: { [weak self] response in
            self?.userImageView.image = response.image
        }).disposed(by: disposeBag)
    }
    
}
