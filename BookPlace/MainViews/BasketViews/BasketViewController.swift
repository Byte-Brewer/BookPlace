//
//  BasketViewController.swift
//  BookPlace
//
//  Created by Nazar on 04.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import CoreData

class BasketViewController: UIViewController {
    
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
