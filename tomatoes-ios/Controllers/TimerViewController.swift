//
//  TimerViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/21/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

class TimerViewController: UIViewController {
    
    var tomatoesCount = 0
    
    lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 120, weight: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .whiteSnow
        label.textAlignment = .center
        label.text = "\(TomatoType.work.rawValue)\n00"
        return label
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.backgroundColor = .whiteSnow
        button.setTitle("PAUSE", for: .normal)
        button.addTarget(self, action: #selector(pause), for: .touchUpInside)
        return button
    }()
    
    func setColor(color: UIColor) {
        view.backgroundColor = color
        pauseButton.setTitleColor(color, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        setColor(color: .redTomato)
        setupViews()
        
        if !Session.isAuthenticated {
            let auth = GithubAuthViewController()
            navigationController?.present(auth, animated: true, completion: nil)
        }
        
        TomatoesTimer.instance.onTick = { (minutes, seconds) in
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            self.countdownLabel.text = "\(minutesString)\n\(secondsString)"
        }
        start()
    }
    
    func start() {
        setColor(color: .redTomato)
        TomatoesTimer.instance.start(TomatoType.work.seconds) {
            let save = SaveTomatoViewController { [weak self] in
                self?.startPause()
            }
            save.modalPresentationStyle = .currentContext
            save.modalTransitionStyle = .crossDissolve
            self.present(save , animated: true) {
                self.setColor(color: .lightGreen)
            }
        }
    }
    
    func pause() {
        TomatoesTimer.instance.stop()
        dismiss(animated: true, completion: nil)
    }
    
    func startPause() {
        tomatoesCount = tomatoesCount + 1
        let tomatoType: TomatoType = tomatoesCount % 4 == 0 ? .shortBreak : .longBreak
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
        view.addSubview(pauseButton)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [pauseButton.widthAnchor.constraint(equalToConstant: 120),
                                        pauseButton.heightAnchor.constraint(equalToConstant: 120),
                                        pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        
        constraints.append(contentsOf: [countdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                       countdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                       countdownLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                       countdownLabel.bottomAnchor.constraint(equalTo: pauseButton.topAnchor)])
        NSLayoutConstraint.activate(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

