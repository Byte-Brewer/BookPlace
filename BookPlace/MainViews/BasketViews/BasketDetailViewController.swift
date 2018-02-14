//
//  BasketDetailViewController.swift
//  BookPlace
//
//  Created by Nazar on 04.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class BasketDetailViewController: UIViewController {
    
    var bookFromCart: Cart?
    var bookFromItem: Item?
    let context = CoreDataManager.instance.persistentContainer.viewContext
    
    @IBOutlet weak var bookView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.navigationItem.title = "Book Info"
    }
    
    func setupView(){
        if bookFromCart != nil {
            authorLabel.text = bookFromCart?.author ?? "Without author"
            titleLabel.text = bookFromCart?.title ?? "Unknown"
            descriptionLAbel.text = bookFromCart?.detail
            if let imageData = bookFromCart?.image {
                bookView.image = UIImage.init(data: imageData)
            } else {
                bookView.image = UIImage.init(named: "bookPlaceHolder")
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(removeFromCard))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        } else {
            authorLabel.text = bookFromItem?.volumeInfo.authors?.first ?? "Without author"
            titleLabel.text = bookFromItem?.volumeInfo.title ?? "Unknown"
            descriptionLAbel.text = bookFromItem?.volumeInfo.description ?? "( ͡° ͜ʖ ͡°)﻿"
            if let imageData = bookFromItem?.volumeInfo.imageLinks?.thumbnail {
                bookView.kf.setImage(with: URL(string: imageData))
            } else {
                bookView.image = UIImage.init(named: "bookPlaceHolder")
            }
        }
    }
    
    func setUp() {
        setupView()
        guard let oneBook = bookFromItem else {
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        request.predicate = NSPredicate(format: "id = %@", oneBook.id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Cart]
            print("result from core data Card with Predicate: ", result.count)
            if let _ = result.first {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(removeFromCard))
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to Cart", style: .plain, target: self, action: #selector(addToCart))
            }
        } catch {
            print("Failed")
        }
    }
    
    @objc func addToCart() {
        self.navigationItem.rightBarButtonItem = nil
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        let newBook = NSManagedObject(entity: entity!, insertInto: context)
        if bookFromItem != nil {
            newBook.setValue(bookFromItem?.volumeInfo.authors?.first ?? "Unknown Author", forKey: "author")
            newBook.setValue(bookFromItem?.volumeInfo.title ?? "Wihtout Title", forKeyPath: "title")
            newBook.setValue(bookFromItem?.volumeInfo.description ?? ":)", forKeyPath: "detail")
            newBook.setValue(bookFromItem?.id, forKey: "id")
            if let data = NSData(contentsOf: URL(string: (bookFromItem?.volumeInfo.imageLinks?.thumbnail)!)!) {
                newBook.setValue(data, forKey: "image")
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        (self.tabBarController as! BookPlaceTBC).refreshCartCount()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeFromCard() {
        self.navigationItem.rightBarButtonItem = nil
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let predicate = self.bookFromCart?.id ?? self.bookFromItem?.id
        request.predicate = NSPredicate(format: "id = %@", predicate!)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Cart]
            print("result from core data Card: ", result.count)
            if let object = result.first {
                context.delete(object)
            }
        } catch {
            print("Failed")
        }
        (self.tabBarController as! BookPlaceTBC).refreshCartCount()
        _ = self.navigationController?.popViewController(animated: true)
    }
}
