//
//  DetailRepoViewController.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/6/21.
//

import UIKit
import WebKit

class DetailRepoViewController: UIViewController {
    
    var repo : Repository?
    
    @IBOutlet weak private var repoWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        self.navigationItem.title = repo?.repoName
        
        repoWebView.uiDelegate = self
        let myURL = URL(string:repo?.repoUrl ?? "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        repoWebView.load(myRequest)
    }
    
}

extension DetailRepoViewController : WKUIDelegate{
    
}
