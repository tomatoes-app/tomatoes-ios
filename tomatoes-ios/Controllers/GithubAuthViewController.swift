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

    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "GitHub-Big")
        image.tintColor = .whiteSnow
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .whiteSnow
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    func setupViews() {
        webview.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        webview.backgroundColor = .clear
        webview.isOpaque = false
        view.addSubview(logoImage)
        view.addSubview(loadingLabel)
        view.addSubview(webview)
        
        NSLayoutConstraint.activate([logoImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.3),
                                     logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
                                     loadingLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor),
                                     loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     webview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     webview.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                     webview.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
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
                session.create { (result) in
                    switch result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error): print(error?.localizedDescription ?? "no error description")
                    }
                }
            }
        }
        return false
    }
}
