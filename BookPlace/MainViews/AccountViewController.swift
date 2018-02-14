//
//  AccountViewController.swift
//  BookPlace
//
//  Created by Nazar on 03.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreData

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewContainer.layer.cornerRadius = self.view.frame.size.width / 4
        imageViewContainer.clipsToBounds = true
        getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUser()
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        if let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            GIDSignIn.sharedInstance().signOut()
            print("Exit")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    func getUser() {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [User]
            print("result count: ", result.count)
            if let user = result.last {
                nameLabel.text = user.name
                if let imageData = user.imageUser {
                    avatarImage.image = UIImage(data: imageData)
                } else {
                    avatarImage.image = UIImage.init(named: "noMale")
                }
            }
        } catch {
            print("Failed")
        }
        print("User")
    }
}
