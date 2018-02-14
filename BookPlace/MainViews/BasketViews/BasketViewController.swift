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
    
    fileprivate var books = [Cart]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBooksFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBooksFromCoreData()
        tableView.reloadData() 
    }
        
    private func getBooksFromCoreData() {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Cart]
            books = result
        } catch {
            print("Failed")
        }
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "bascketCell") as! SearchCell
        cell.setup(cart: cart)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasketDVC") as! BasketDetailViewController
        detailsVC.bookFromCart = books[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
