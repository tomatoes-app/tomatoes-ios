//
//  Config.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import Foundation

enum Config: String {
    case githubClientId = "github_client_id"
    case githubClientSecret = "github_client_secret"
    
    var value: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist")  else {
           assertionFailure("You need to create a Config.plist file with 'github_client_id' and 'github_client_secret'. Do not push publically this sensitive information.")
            return ""
        }
        let config = NSDictionary(contentsOfFile: path)
        return config?[rawValue] as? String ?? ""
    }
}
