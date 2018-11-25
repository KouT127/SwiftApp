//
//  ImagePickerService.swift
//  SwiftApp
//
//  Created by kou on 2018/11/25.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxMediaPicker
import FirebaseFirestore


class ImagePickerService {
    weak var viewController: UIViewController!
    
    var picker: RxMediaPicker!
    let disposeBag = DisposeBag()
    
    required init(vc: UIViewController) {
        self.viewController = vc
        picker = RxMediaPicker(delegate: self)
    }
    
    public func pickPhoto() -> Observable<(UIImage,UIImage?)>{
        return picker.selectImage(editable: true)
    }
}

extension ImagePickerService: RxMediaPickerDelegate {
    
    func present(picker: UIImagePickerController) {
        self.viewController?.present(picker, animated: true, completion: nil)
    }
    func dismiss(picker: UIImagePickerController) {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
