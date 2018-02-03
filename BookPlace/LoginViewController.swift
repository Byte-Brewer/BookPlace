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
    }

    @IBAction func googleLoginButton(_ sender: UIButton) {
        print("Google")
        oAuthGoogle.sendActions(for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Yes", GIDSignIn.sharedInstance().clientID)
            if let bookPlaceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookPlaceSB") as? BookPlaceViewController {
                self.present(bookPlaceVC, animated: true, completion: nil)
            }
        } else {
            print("No")
        }
    }
}
