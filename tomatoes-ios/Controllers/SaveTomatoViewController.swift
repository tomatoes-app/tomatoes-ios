//
//  SaveTomatoViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

class SaveTomatoViewController: UIViewController {
    
    var onDismiss: (()->())?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedDigitSystemFont(ofSize: 90, weight: 200)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.clipsToBounds = false
        return textView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.backgroundColor = .white
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        textView.becomeFirstResponder()
    }
    
    init(onDismiss: (()->())? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.onDismiss = onDismiss
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func save() {
        let taglist = textView.text ?? ""
        let tomato = Tomato()
        tomato.tagList = taglist
        tomato.create { [weak self] (result) in
            switch result {
            case .success: self?.onDismiss?()
            case .failure(let error): print(error?.localizedDescription ?? "")
            }
            
        }
    }
    

    func setupViews() {
        view.backgroundColor = UIColor.cyan.withAlphaComponent(0.6)
        view.addSubview(textView)
        view.addSubview(saveButton)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [saveButton.widthAnchor.constraint(equalToConstant: 120),
                                        saveButton.heightAnchor.constraint(equalToConstant: 120),
                                        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        
        constraints.append(contentsOf: [textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                        textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                        textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
                                        textView.bottomAnchor.constraint(equalTo: saveButton.topAnchor)])
        NSLayoutConstraint.activate(constraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
