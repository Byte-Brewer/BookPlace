//
//  SearchViewController.swift
//  BookPlace
//
//  Created by Nazar on 04.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    fileprivate var books = [Item]() {
        didSet {
            if oldValue.count != books.count {
                loadMore = true
            }
        }
    }
    private var searchText = "Harry Potter"
    fileprivate var loadMore = true
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBarView: UISearchBar!{
        didSet {
            searchBarView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarView.text = searchText
        getBookFromAPI()
    }
    
    private func getBookFromAPI() {
        guard Connectivity.isConnectedToInternet() else {
            return
        }
        guard !searchText.hasPrefix(" ") else {
            searchText = searchText.replacingOccurrences(of: " ", with: "")
            return
        }
        RestAPIManager().searchBook(searchText: searchText, offset: books.count) { some in
            if let books = some?.items {
                self.books += books
                self.tableView.reloadData()
                self.setBookCountInTabBar()
            }
        }
    }
    private func setBookCountInTabBar() {
        (self.tabBarController as! BookPlaceTBC).bookTabBar.items![0].badgeValue = String(books.count)
    }
    
    // MARK: - SearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchText = searchBar.text ?? "Hary Potter"
        self.books.removeAll()
        getBookFromAPI()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let volumInfo = books[indexPath.row].volumeInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        cell.setup(volumInfo: volumInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard loadMore else {
            return
        }
        if (indexPath.row + 2) >= self.books.count {
            loadMore = false
            getBookFromAPI()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasketDVC") as! BasketDetailViewController
        detailsVC.bookFromItem = books[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
