//
//  ViewController.swift
//  BookPlace
//
//  Created by Nazar on 03.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var oAuthGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GIDSignIn.sharedInstance().uiDelegate = self
    }

    @IBAction func faceBookLoginButton(_ sender: UIButton) {
        print("FaceBook")
        GIDSignIn.sharedInstance().signOut()
    }

    @IBAction func googleLoginButton(_ sender: UIButton) {
        print("Google")
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Yes", GIDSignIn.sharedInstance().clientID)
        } else {
            print("No")
        }
    }
}
