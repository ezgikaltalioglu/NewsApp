//
//  FavorilerDetay.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 16.09.2023.
//

import UIKit
import WebKit

class FavorilerDetay: UIViewController {

    @IBOutlet weak var favoriWebView: WKWebView!
    var haberURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: haberURL ?? "") {
                    let request = URLRequest(url: url)
                    favoriWebView.load(request)
                }
    }
    

}
