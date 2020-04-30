//
//  ViewController.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 3/26/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(launchedBefore) {
            performSegue(withIdentifier: "autoLogIn", sender: self)
        }
    }
    
    
}

