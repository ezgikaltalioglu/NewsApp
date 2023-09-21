//
//  HaberDetayEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 8.09.2023.
//

import UIKit
import WebKit

class HaberDetayEkrani: UIViewController {


    @IBOutlet weak var webview: WKWebView!
    
    var haberURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = haberURL {
                    let request = URLRequest(url: url)
                    webview.load(request)
                }
        
    }
    



}
