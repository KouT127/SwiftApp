//
//  sampleWebView.swift
//  SwiftApp
//
//  Created by kou on 2018/10/29.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class SampleWebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var viewModel: SampleViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
        
    private func setupWebView() {
        
        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("denit")
    }
}
