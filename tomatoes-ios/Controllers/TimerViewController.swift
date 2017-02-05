//
//  TimerViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/21/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

let magentaInk = UIColor(red: 255/255, green: 0, blue: 144/255, alpha: 1)

class TimerViewController: UIViewController {
    
    var tomatoesCount = 0
    
    lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 140, weight: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "\(TomatoType.work.rawValue)m\n00s"
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.backgroundColor = .white
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        return button
    }()
    
    func setColor(color: UIColor) {
        view.backgroundColor = color
        startButton.setTitleColor(color, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(color: magentaInk)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        
        if !Session.isAuthenticated {
            let auth = GithubAuthViewController()
            navigationController?.present(auth, animated: true, completion: nil)
        }
        
        TomatoesTimer.instance.onTick = { (minutes, seconds) in
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            self.countdownLabel.text = "\(minutesString)m\n\(secondsString)s"
        }
    }
    
    func start() {
        setColor(color: magentaInk)
        TomatoesTimer.instance.start(TomatoType.work.seconds) {
            let save = SaveTomatoViewController { [weak self] in
                self?.startPause()
            }
            save.modalPresentationStyle = .currentContext
            save.modalTransitionStyle = .crossDissolve
            self.present(save , animated: true) {
                self.setColor(color: .yellow)
            }
        }
    
    }
    
    func startPause() {
        tomatoesCount = tomatoesCount + 1
        let tomatoType: TomatoType = tomatoesCount % 4 == 0 ? .shorBreak : .longBreak
        TomatoesTimer.instance.start(tomatoType.seconds) {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tomato.items(page: 1) { (result) in
            switch result {
            case .success(let page): self.tomatoesCount = page.items?.count ?? 0
            case .failure(let error): print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func setupViews() {
        
        view.addSubview(countdownLabel)
        view.addSubview(startButton)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [startButton.widthAnchor.constraint(equalToConstant: 120),
                                        startButton.heightAnchor.constraint(equalToConstant: 120),
                                        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        
        constraints.append(contentsOf: [countdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                       countdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                       countdownLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                       countdownLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor)])
        NSLayoutConstraint.activate(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

