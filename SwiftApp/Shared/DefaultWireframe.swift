//
//  DefaultWireframe.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DefaultWireframe {
    static let shared = DefaultWireframe()
    
    func promptFor(_ info: AlertInfo) -> Driver<AlertInfo.Action> {
        return alert(info)
            .asDriver(onErrorDriveWith: Driver.empty())
            .flatMap { result in
                return Driver.just(result)
        }
        
    }
    
    private func alert(_ info: AlertInfo) -> Observable<AlertInfo.Action> {
        return Observable<AlertInfo.Action>.create { observer in
            let alertView = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
            if let cancelAction = info.cancel {
                alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                    observer.onNext(AlertInfo.Action.cancel)
                })
            }
            for action in info.actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.onNext(action)
                })
            }
            UIApplication.topViewController()?.present(alertView, animated: true, completion: nil)
            return Disposables.create {
                alertView.dismiss(animated: false, completion: nil)
            }
        }
    }
}


struct AlertInfo {
    var title: String
    var message: String
    var actions: [Action]
    var cancel: Action?
    
    init(title: String, message: String, actions: [Action] = [], cancel: Action? = nil) {
        self.title = title
        self.message = message
        self.actions = actions
        self.cancel = cancel
    }
    
    enum Action: String {
        case ok = "OK"
        case confirm = "確認"
        case cancel = "キャンセル"
        var description: String { return self.rawValue }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
