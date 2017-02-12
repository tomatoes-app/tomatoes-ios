//
//  WelcomeViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 2/12/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

class WelcomeViewController: UIViewController {

    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "Logo")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var githubButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 200)
        button.setTitle("Sign up with GitHub", for: .normal)
        button.setImage(#imageLiteral(resourceName: "GitHub-Mark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(github), for: .touchUpInside)
        button.setTitleColor(.whiteSnow, for: .normal)
        button.tintColor = .whiteSnow
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Session.isAuthenticated {
            let dashboardController = DashboardViewController()
            navigationController?.pushViewController(dashboardController, animated: true)
        }
    }
    
    func setupViews() {
        view.addSubview(logoImage)
        view.addSubview(githubButton)

        view.backgroundColor = .whiteSnow
        
        NSLayoutConstraint.activate([logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1),
                                     logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     githubButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                                     githubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     githubButton.heightAnchor.constraint(equalToConstant: 60),
                                     githubButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)])
        
    }
    
    func github() {
        let auth = GithubAuthViewController()
        navigationController?.present(auth, animated: true, completion: nil)
    }
}
