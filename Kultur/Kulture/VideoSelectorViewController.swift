//
//  VideoSelectorViewController.swift
//  Kulture
//
//  Created by bis on 5/14/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit


protocol VideoSelectorDelegate: class {
    func selectedVideoUrl(url: String?)
}


class VideoSelectorViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    weak var delegeate: VideoSelectorDelegate?
    var beginUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: beginUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSelectTap(_ sender: Any) {
        let currentURL = webView.request?.url?.absoluteString
        delegeate?.selectedVideoUrl(url: currentURL)
    }

}
