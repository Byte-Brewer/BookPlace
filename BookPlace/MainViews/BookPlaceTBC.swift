//
//  BookPlaceViewController.swift
//  BookPlace
//
//  Created by Nazar on 04.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import CoreData

class BookPlaceTBC: UITabBarController {
    
    @IBOutlet weak var bookTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCartCount()
    }
    
    func refreshCartCount() {
        var booksCount = 0
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Cart]
            booksCount = result.count
        } catch {
            print("Failed")
        }
        bookTabBar.items![1].badgeValue = String(booksCount)
    }
}
