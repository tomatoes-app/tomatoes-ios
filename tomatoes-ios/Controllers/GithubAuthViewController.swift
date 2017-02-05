//
//  GithubAuthViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Security
import Tomatoes

class GithubAuthViewController: UIViewController {

    let callback = URL(string: "http://ios.tomato.es/")
    let tokenUrl = URL(string: "https://github.com/login/oauth/access_token")
    
    let webview = UIWebView()

    func setupViews() {
        webview.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        view.addSubview(webview)
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                       webview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                       webview.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                       webview.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let params = "client_id=\(Config.githubClientId.value)"
        let urlString = "https://github.com/login/oauth/authorize?\(params)"
        guard let url = URL(string: urlString) else { return }
        
        let req = URLRequest(url: url)
        webview.delegate = self
        webview.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GithubAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let tokenUrl = tokenUrl,
            let url = request.url, let redirect = callback?.host, url.host == redirect,
            let code = url.query?.components(separatedBy: "code=").last else { return true }

        let params = [ "client_id" : Config.githubClientId.value,
            "client_secret" : Config.githubClientSecret.value,
            "code" : code
        ]
        Network.perfomRequest(tokenUrl, parameters: params, method: "POST") { (result, error) in
            let object = result as? JSONObject
            if let accessToken = object?["access_token"] as? String {
                let session = Session(provider: .github, accessToken: accessToken)
                session.create(completion: { (result) in
                    switch result {
                    case .success(let token):
                        print(token)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error): print(error?.localizedDescription ?? "no error description")
                    }
                })
            }
        }
        return false
    }
}
