//
//  AccountViewController.swift
//  BookPlace
//
//  Created by Nazar on 03.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewContainer.layer.cornerRadius = self.view.frame.size.width / 4
        imageViewContainer.clipsToBounds = true
        getProfil()
    }

    @IBAction func logOutAction(_ sender: UIButton) {
        if let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            GIDSignIn.sharedInstance().signOut()
            print("Exit")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    func getProfil() {
        if let profile = GIDSignIn.sharedInstance().currentUser.profile {
            nameLabel.text = (profile.name)!
        }
        if let profileImage = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 150){
            print("profile image: ", profileImage)
            avatarImage.kf.setImage(with: profileImage)
        }
    }
}
