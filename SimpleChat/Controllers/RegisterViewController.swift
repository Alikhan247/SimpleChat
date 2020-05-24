//
//  RegisterViewController.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        if let email = loginTextfield.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    //Navigate to the ChatVC
                    let user = Auth.auth().currentUser
                    
                    if let currentUser = user {
                        self.db.collection(K.FStore.collectionUsers).addDocument(data: [
                            "name": currentUser.displayName ?? "undefined",
                            "email": currentUser.email ?? "undefined",
                            "uid": currentUser.uid,
                            "status": 0,
                            K.FStore.dateField: Date().timeIntervalSince1970
                        ]) { (error) in
                            if let e = error {
                                print("Could not save data: \(e)")
                            } else {
                                print("saved!")
                            }
                        }
                    }
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
