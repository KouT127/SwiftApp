//
//  ImageDetailSection1Cell.swift
//  SwiftApp
//
//  Created by kou on 2018/12/06.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import Nuke
import RxSwift
import RxCocoa

class ImageDetailSectionOneCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func postImageDisplay(_ image: Single<ImageResponse>) {
        mainImage?.image = UIImage(named: "PlaceHolder")
        image.subscribe(onSuccess: { [weak self] response in
            self?.mainImage?.image = response.image
        }).disposed(by: disposeBag)
    }
    
}
