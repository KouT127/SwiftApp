//
//  Router.swift
//  SwiftApp
//
//  Created by kou on 2018/11/14.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RealmSwift

class Router: UIViewController {
    
    let accessor: Accessor = .shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentTopView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func presentTopView() {
        let storyBoard = getStoryBoard()
        //withIdentifierに遷移先のstoryboardID
        let vc = storyBoard.instantiateInitialViewController()!
        DispatchQueue.main.async {
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    private func getStoryBoard() -> UIStoryboard {
        let auth = UIStoryboard(name: "FirebaseAuth", bundle: nil)
        let list = UIStoryboard(name: "ImageDetailTableView", bundle: nil)
        return validateAuth() ? list : auth
    }
    
    private func validateAuth() -> Bool {
        let user = accessor.realm.objects(AuthUser.self)
        print(user.isEmpty)
        return !user.isEmpty
    }
}
