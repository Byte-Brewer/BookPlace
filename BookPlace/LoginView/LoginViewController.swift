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
        login()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func faceBookLoginButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ups", message: "This action is temporarily unavailable", preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        let actionCamon = UIAlertAction(title: "May be Google?", style: UIAlertActionStyle.default, handler: { _ in self.googleLoginButton(UIButton()) })
        alert.addAction(actionOK)
        alert.addAction(actionCamon)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func googleLoginButton(_ sender: UIButton) {
        oAuthGoogle.sendActions(for: .touchUpInside)
    }
    
    func login() {
        guard Connectivity.isConnectedToInternet() else {
            let alert = UIAlertController(title: "Error", message: "Inretnet is avalible", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
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
            let email = user.profile.email
            let fullName = user.profile.name
            let userId = user.userID
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            if let avatarURL = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 250) {
                print("URL: ", avatarURL.absoluteString)
                let image = NSData(contentsOf: avatarURL)
                newUser.setValue(image, forKey: "imageUser")
                newUser.setValue(avatarURL.absoluteString, forKey: "avatarURL")
            }
            
            newUser.setValue(fullName, forKey: "name")
            newUser.setValue(email, forKey: "email")
            newUser.setValue(userId, forKey: "userID")
                
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            self.login()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("end tut")
    }
}
