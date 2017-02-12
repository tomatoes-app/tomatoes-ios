//
//  DashboardViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 2/5/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

enum DashboardInfo: Int {
    
    static let identifier = "InfoIdentifier"
    
    case todayTomatoes
    case weekTomtoes
    case mounthTomatoes
    
    func value(from user: User?) -> String {
        switch self {
        case .todayTomatoes: return "\(user?.tomatoesCounters?.day ?? 0)"
        case .weekTomtoes: return "\(user?.tomatoesCounters?.week ?? 0)"
        case .mounthTomatoes: return "\(user?.tomatoesCounters?.month ?? 0)"
        }
    }
    var title: String {
        switch self {
        case .todayTomatoes: return "Daily"
        case .weekTomtoes: return "Weekly"
        case .mounthTomatoes: return "Monthly"
        }
    }
}

class DashboardViewController: UIViewController {
    
    var user: User?
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .redTomato
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .redTomato
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchUser()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(profileImage)
        view.addSubview(startButton)
        view.backgroundColor = .whiteSnow
        let circleDimension = view.frame.width * 0.32
        let margin = view.frame.width * 0.05
        
        NSLayoutConstraint.activate([startButton.widthAnchor.constraint(equalToConstant: circleDimension),
                                     startButton.heightAnchor.constraint(equalToConstant: circleDimension),
                                     startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
                                     profileImage.widthAnchor.constraint(equalToConstant: circleDimension),
                                     profileImage.heightAnchor.constraint(equalToConstant: circleDimension),
                                     profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: margin * 2),
                                     tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     tableView.topAnchor.constraint(equalTo: profileImage.bottomAnchor,  constant: margin),
                                     tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor),
                                     tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        startButton.layer.cornerRadius = circleDimension / 2
        profileImage.layer.cornerRadius = circleDimension / 2
        tableView.dataSource = self
        tableView.delegate = self
    }

    func refresh() {
        if let stringUrl = user?.image,
            let url = URL(string: stringUrl),
            let data = try? Data(contentsOf: url) {
                profileImage.image = UIImage(data: data)
        }
    }

    func fetchUser() {
        User.read { (result) in
            switch result {
            case .success(let user):
                self.user = user
                self.refresh()
                self.tableView.reloadData()
            case .failure(let error): print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func start() {
        let timerController = TimerViewController()
        timerController.tomatoesCount = user?.tomatoesCounters?.day ?? 0
        present(timerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DashboardInfo.identifier)
        if cell == nil {
             cell = UITableViewCell(style: .value1, reuseIdentifier: DashboardInfo.identifier)
        }
        let info = DashboardInfo(rawValue: indexPath.row)
        cell?.backgroundColor = .clear
        cell?.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: 200)
        cell?.textLabel?.textColor = .redTomato
        cell?.textLabel?.text = info?.title
        cell?.detailTextLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: 200)
        cell?.detailTextLabel?.textColor = .redTomato
        cell?.detailTextLabel?.text = info?.value(from: user)

        return cell ?? UITableViewCell()
    }
}
