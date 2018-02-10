//
//  ViewController.swift
//  BookPlace
//
//  Created by Nazar on 03.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreData

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    @IBOutlet weak var oAuthGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func faceBookLoginButton(_ sender: UIButton) {
        print("FaceBook")
    }
    
    @IBAction func googleLoginButton(_ sender: UIButton) {
        print("Google")
        oAuthGoogle.sendActions(for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        login()
    }
    
    func login() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Yes", GIDSignIn.sharedInstance().clientID)
            if let bookPlaceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookPlaceSB") as? BookPlaceTBC {
                self.present(bookPlaceVC, animated: true, completion: nil)
            }
        } else {
            print("No")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("tut")
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            if let avatarURL = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 100) {
                print("URL: ", avatarURL.absoluteString)
                newUser.setValue(avatarURL.absoluteString, forKey: "avatarURL")
            }
            
            newUser.setValue(fullName, forKey: "name")
            newUser.setValue(email, forKey: "email")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("end tut")
    }
}
