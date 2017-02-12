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
    var currentType: TomatoType = TomatoType.work {
        didSet {
            if currentType == .work {
                titleLabel.text = "Let's work!"
                setColor(color: .redTomato)
            } else {
                titleLabel.text = "Take a break!"
                setColor(color: .lightGreen)
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .whiteSnow
        label.textAlignment = .center
        return label
    }()
    
    lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 120, weight: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .whiteSnow
        label.textAlignment = .center
        label.text = "\(Int(TomatoType.work.rawValue))\n00"
        return label
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .whiteSnow
        button.setTitle("CANCEL", for: .normal)
        button.addTarget(self, action: #selector(stopTomato), for: .touchUpInside)
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
        
        TomatoesTimer.instance.onTick = { (minutes, seconds) in
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            self.countdownLabel.text = "\(minutesString)\n\(secondsString)"
        }
        
        start(type: TomatoType.work)
    }
    
    func start(type: TomatoType) {
        currentType = type
        LocalNotification.scheduleNotification(title: currentType.notificationTitle, timeInterval: TimeInterval(currentType.seconds))
        TomatoesTimer.instance.start(currentType.seconds) { [weak self] in
            switch type {
            case .work: self?.saveTomato()
            default: self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func saveTomato() {
        let save = SaveTomatoViewController { [weak self] in
            self?.startPause()
        }
        save.modalPresentationStyle = .currentContext
        save.modalTransitionStyle = .crossDissolve
        self.present(save , animated: true) {
            self.setColor(color: .lightGreen)
        }
    }
    
    func stopTomato() {
        TomatoesTimer.instance.stop()
        LocalNotification.cancelNotification()
        dismiss(animated: true, completion: nil)
    }
    
    func startPause() {
        tomatoesCount = tomatoesCount + 1
        currentType = tomatoesCount % 4 == 0 ? .shortBreak : .longBreak
        start(type: currentType)
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
        
        view.addSubview(titleLabel)
        view.addSubview(countdownLabel)
        view.addSubview(pauseButton)
        
        let circleDimension = view.frame.width * 0.32
        let margin = view.frame.width * 0.05
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [pauseButton.widthAnchor.constraint(equalToConstant: circleDimension),
                                        pauseButton.heightAnchor.constraint(equalToConstant: circleDimension),
                                        pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin)])
        
        constraints.append(contentsOf: [countdownLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                       countdownLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                       countdownLabel.bottomAnchor.constraint(equalTo: pauseButton.topAnchor)])
        
        constraints.append(contentsOf: [titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                        titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                        titleLabel.bottomAnchor.constraint(equalTo: countdownLabel.topAnchor)])
        pauseButton.layer.cornerRadius = circleDimension / 2

        NSLayoutConstraint.activate(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

