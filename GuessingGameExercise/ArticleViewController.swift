//
//  ArticleViewController.swift
//  GuessingGameExercise
//
//  Created by Björn Kaczmarek on 22/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    public var webViewURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
    }
    
    func configureWebView() {
        webView.navigationDelegate = self
        webView.load(URLRequest (url:URL(string: webViewURL)!))
    }
}
