//
//  ViewController.swift
//  SwiftApp
//
//  Created by kou on 2018/08/20.
//  Copyright © 2018年 kou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presentTopView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
        return UIStoryboard(name: "Router", bundle: nil)
    }



}

