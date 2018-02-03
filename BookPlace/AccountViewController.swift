//
//  AccountViewController.swift
//  BookPlace
//
//  Created by Nazar on 03.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import GoogleSignIn

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logOutAction(_ sender: UIButton) {
        if let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            GIDSignIn.sharedInstance().signOut()
            print("Exit")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
