//
//  InformationVC.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit
import WebKit

class InformationVC: UIViewController {
    
    var wikiURL: String = ""
    
    @IBOutlet weak var mActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mWebArea: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: wikiURL)!)
        mWebArea.load(request)
        
        mWebArea.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading" {
            if mWebArea.isLoading {
                mActivityIndicator.startAnimating()
                mActivityIndicator.isHidden = false
            }
            else {
                mActivityIndicator.stopAnimating()
                mActivityIndicator.isHidden = true
            }
        }
        
        
    }
}
